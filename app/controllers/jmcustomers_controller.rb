class JmcustomersController < ApplicationController
   skip_before_action :verify_authenticity_token, only: [:sms_callback]

 before_action :set_jmcustomer, only: %i[ show edit update destroy send_offer_sms ]
 #before_action :set_jmpayment, only: [:show]
 before_action :set_jmpayment, only: [:edit_payment, :update_payment, :destroy_payment] 


# app/controllers/jmcustomers_controller.rb
#def send_offer_sms_to_all
 # SendOfferSmsJob.perform_later
 # redirect_to jmcustomers_path,
          #    notice: "Offer SMS sending started in the background. This may take a few minutes."
#end


 # ✅ Send to All Customers
def send_offer_sms_to_all
  Rails.logger.info("🚀 send_offer_sms_to_all STARTED")

  sms_service = TextsmsService.new(
    api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
    partner_id: '14784',
    shortcode: 'JANOMAX'
  )

  customers = Jmcustomer.all
  sent_count = 0

  customers.each do |c|
    next if c.phone.blank?

    Rails.logger.info("📤 Sending to #{c.phone}")

    begin
      sms_service.send_sms(c.phone, "Test message")
      sent_count += 1
    rescue => e
      Rails.logger.error("❌ Failed: #{e.message}")
    end
  end

  Rails.logger.info("✅ Done. Sent: #{sent_count}")

  redirect_to jmai_index_path, notice: "Sent to #{sent_count} customers"
end



# GET /jmcustomers
def index
  check_sms_balance

  per_page = params[:per_page].presence.to_i
  per_page = 5 if per_page.zero?

  @jmcustomers = Jmcustomer.includes(:janomaxes)

  # ============================================
  # BLACKLIST FILTER
  # ============================================
  if params[:blacklist] == "true"
    @jmcustomers = @jmcustomers.where(blacklist: true)
  end

  # ============================================
  # SEARCH
  # ============================================
  if params[:search].present?
    search = "%#{params[:search].strip}%"

    @jmcustomers = @jmcustomers.where(
      "name ILIKE :search
       OR phone ILIKE :search
       OR location ILIKE :search
       OR comments ILIKE :search
       OR feedback ILIKE :search
       OR callcomments ILIKE :search",
      search: search
    )
  end

  # ============================================
  # ORDER + PAGINATION
  # ============================================
  @jmcustomers = @jmcustomers
    .order(updated_at: :desc)
    .page(params[:page])
    .per(per_page)

  # ============================================
  # CSV / XLSX EXPORT
  # ============================================
  @jmcustomersa = @jmcustomers.except(:limit, :offset)

  respond_to do |format|
    format.html

    format.csv do
      filename = "jcustomers_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"

      send_data Jmcustomer.to_csv(@jmcustomersa),
                filename: filename
    end

    format.xlsx do
      filename = "jcustomers_#{Time.current.strftime('%Y%m%d_%H%M%S')}.xlsx"

      response.headers["Content-Disposition"] =
        "attachment; filename=#{filename}"
    end

    format.js
  end
end

  def show
  @jmcustomer = Jmcustomer.find(params[:id])

  # Build one empty jmcustomer_item if none exist
  @jmcustomer.jmcustomer_items.build if @jmcustomer.jmcustomer_items.empty?

  # Prepare a fresh payment for the form
  @jmpayment = @jmcustomer.jmpayments.new
end

  def import
    Jmcustomer.import(params[:file])
    redirect_to jmcustomers_path, notice: "Janomax Customers imported successfully."
  end

  def new
    @jmcustomer = Jmcustomer.new
    @jmcustomer.jmcustomer_items.build
  end

  def edit
    @jmcustomer = Jmcustomer.find(params[:id])
    @jmcustomer.jmcustomer_items.build if @jmcustomer.jmcustomer_items.empty?
     @jmpayment = @jmcustomer.jmpayments.new
  end

  def create
  existing_customer = Jmcustomer.find_by(phone: jmcustomer_params[:phone])
  if existing_customer
    flash[:alert] = "Customer with phone #{jmcustomer_params[:phone]} already exists. Redirected to edit page."
    redirect_to edit_jmcustomer_path(existing_customer, turbo: false) and return
  end

  @jmcustomer = Jmcustomer.new(jmcustomer_params)

  if @jmcustomer.save
    create_fulfillment_for_new_items(@jmcustomer)
    send_thank_you_sms(@jmcustomer)
    redirect_to @jmcustomer, notice: "Customer was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end

def update
  previous_updated_at = @jmcustomer.updated_at

  if @jmcustomer.update(jmcustomer_params)
    @jmcustomer.reload

    transaction_ref = @jmcustomer.jmpayments.last&.transaction_ref

    if transaction_ref.present?
      upsert_fulfillment(@jmcustomer, transaction_ref)
    end

    if @jmcustomer.updated_at != previous_updated_at
      @jmcustomer.update(returning: true) unless @jmcustomer.returning?
      send_thank_you_sms(@jmcustomer)
    end

    redirect_to jmcustomers_path, notice: "Customer updated"
  else
    render :edit, status: :unprocessable_entity
  end
end



def redeem
    customer = Jmcustomer.find(params[:jmcustomer_id])
    points = params[:points].to_i

    customer.redeem_points!(points)

    JmrewardRedemption.create!(
      jmcustomer: customer,
      points: points,
      redeemed_by: current_user.email
    )

    redirect_to jrewards_path, notice: "✅ #{points} points redeemed for #{customer.name}"
  rescue => e
    redirect_to jrewards_path, alert: "❌ #{e.message}"
  end

  def search
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @jmcustomers = Jmcustomer.none.page(params[:page]).per(20)
      flash.now[:alert] = "No search criteria provided."
    else
      @y = Jmcustomer.ransack(params[:q])
      @jmcustomers = @y.result.order(updated_at: :desc).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @jmcustomerss.to_csv, filename: "customers-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
    end
  end

   def query
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @jmcustomers = Jmcustomer.none.page(params[:page]).per(20)
      flash.now[:alert] = "No search criteria provided."
    else
      @y = Jmcustomer.ransack(params[:q])
      @jmcustomers = @y.result.order(updated_at: :desc).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @jmcustomerss.to_csv, filename: "customers-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
    end
  end

  def destroy
    @jmcustomer.destroy!
    respond_to do |format|
      format.html { redirect_to jmcustomers_path, notice: "Jmcustomer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def update_callcomments
  @jmcustomer = Jmcustomer.find(params[:id])

  new_text = params[:new_callcomment].to_s.strip
  timestamp = Time.current.strftime("%Y-%m-%d %H:%M")

  if new_text.present?
    entry = "[#{timestamp}] #{new_text}"

    # Append to old comments
    @jmcustomer.callcomments =
      [@jmcustomer.callcomments, entry].compact.join("\n\n")

    @jmcustomer.save!
  end

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @jmcustomer }
  end
end


def sms_balance
  sms_service = TextsmsService.new(
    api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
    partner_id: '14784',
    shortcode: 'JANOMAX'
  )

  balance = sms_service.balance

  if balance.is_a?(Hash) && balance["error"]
    redirect_to jmcustomers_path, alert: "Failed to fetch SMS balance: #{balance['error']}"
  else
    redirect_to jmcustomers_path, notice: "You have #{balance} SMS units remaining."
  end
end



 # ✅ Send Offer SMS to One Customer
  def send_offer_sms
    if @jmcustomer.phone.blank?
      redirect_to jmcustomers_path, alert: "Customer #{@jmcustomer.name} has no phone number."
      return
    end

    sms_service = TextsmsService.new(
      api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
      partner_id: '14784',
      shortcode: 'JANOMAX'
    )

    message = "Dear #{@jmcustomer.name}, you currently have #{@jmcustomer.points} reward points. Enjoy an exclusive offer on your next bale at Janomax Premium Bales — valid for 2 days only!"

    response = sms_service.send_sms(@jmcustomer.phone, message)
    Rails.logger.info "📞 Offer SMS sent to #{@jmcustomer.name} (#{@jmcustomer.phone}): #{response.inspect}"

    redirect_to jmcustomers_path, notice: "Offer SMS sent to #{@jmcustomer.name}."
  rescue => e
    Rails.logger.error "❌ Failed to send SMS: #{e.message}"
    redirect_to jmcustomers_path, alert: "Failed to send SMS to #{@jmcustomer.name}."
  end




  private

  def set_jmcustomer
    @jmcustomer = Jmcustomer.find(params[:id])
  end



def set_jmpayment
  @jmpayment = Jmpayment.find(params[:id])
  @jmcustomer = @jmpayment.jmcustomer
end

  def jmcustomer_params
    params.require(:jmcustomer).permit(
      :name, :phone, :location, :returning, :callcomments, :points, :imported, :feedback, :comments, :blacklist,
      jmcustomer_items_attributes: [:id, :janomax_id, :_destroy],
      jfulfillment_attributes: [:id] 
    )
  end


  def create_fulfillment_for_new_items(customer)
  return if customer.jmcustomer_items.blank?

  Jfulfillment.create!(
    jmcustomer: customer,
    name: customer.name,
    phone: customer.phone,
    location: customer.location || "Unknown",
    items: customer.jmcustomer_items
                   .joins(:janomax)
                   .pluck("janomaxes.item_name")
                   .join(", "),
    status: "Pending",
    feedback: customer.feedback,
    comments: customer.comments
  )
end


def upsert_fulfillment(customer, transaction_ref)
  return if transaction_ref.blank?

  fulfillment = Jfulfillment.find_or_initialize_by(
    jmcustomer_id: customer.id,
    transaction_ref: transaction_ref
  )

  is_new = fulfillment.new_record?

  fulfillment.assign_attributes(
    name: customer.name,
    phone: customer.phone,
    location: customer.location || "Unknown",
    items: customer.jmcustomer_items
                   .joins(:janomax)
                   .pluck("janomaxes.item_name")
                   .join(", ")
  )

  if is_new
    fulfillment.feedback = customer.feedback
    fulfillment.comments = customer.comments
    fulfillment.status = "Pending"
  end

  fulfillment.save!
end

  # ✅ Send Thank-You SMS on Create or Update
def send_thank_you_sms(customer)
  sms_service = TextsmsService.new(
    api_key: '07f5a8a2cbf54a4bb8cd42eff0b28ece',
    partner_id: '14784',
    shortcode: 'JANOMAX'
  )

  first_name = customer.name.to_s.strip.split(' ').first
 points = @jmcustomer.points || 0

message = "Dear #{first_name}, thank you for purchasing a bale with Janomax Premium Bales. You now have #{points} reward points. We appreciate your continued support!"
  
  response = sms_service.send_sms(customer.phone, message)
  Rails.logger.info("Thank-you SMS sent to #{customer.phone}: #{response}")
end
end
