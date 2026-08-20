class JmleadsController < ApplicationController
  before_action :set_jmlead, only: %i[ show edit update destroy ]
before_action :authenticate_user!




# GET /jmleads
def index
  per_page = params[:per_page].to_i
  per_page = 5 if per_page <= 0

  @jmleads = Jmlead.all

  # ==================================================
  # STAFF
  # ==================================================


  # ==================================================
  # FILTERS
  # ==================================================

case params[:filter]
when "open"
  @jmleads = @jmleads.where(status: "open")

when "uncontacted"
  @jmleads = Jmlead.uncontacted
                   .order(last_customer_message_at: :desc)

when "converted"
  @jmleads = @jmleads.where(status: "converted")

  end

  # ==================================================
  # SEARCH
  # ==================================================

  if params[:search].present?
    q = "%#{params[:search].strip}%"

    @jmleads = @jmleads.where(
      "name ILIKE :q OR
       phone ILIKE :q OR
       items_required ILIKE :q OR
       status ILIKE :q OR
       sglid::text ILIKE :q",
      q: q
    )
  end

# ============================================
# UNCONTACTED DAYS
# Last 30 days
# Only show dates that actually have
# uncontacted leads.
#
# Includes:
# - OPEN
# - CONVERTED
# ============================================

@uncontacted_days = (0..29).filter_map do |i|

  date = Date.current - i

  count = Jmlead.uncontacted
                .where(last_customer_message_at: date.all_day)
                .count

  next if count.zero?

  {
    date: date,
    count: count
  }

end


# ============================================
# PERIOD FILTER
# ============================================

case params[:period]

when "today"

  date = Time.zone.today.strftime("%d %b %Y")

  @jmleads = @jmleads.where(
    "conversation LIKE ? OR conversation LIKE ?",
    "%#{date}%",
    "%Posted: #{date}%"
  )


when "yesterday"

  date = 1.day.ago.strftime("%d %b %Y")

  @jmleads = @jmleads.where(
    "conversation LIKE ? OR conversation LIKE ?",
    "%#{date}%",
    "%Posted: #{date}%"
  )


when "week"

  conditions = []
  values = []

  (Time.zone.today.beginning_of_week..Time.zone.today.end_of_week).each do |day|

    date = day.strftime("%d %b %Y")

    conditions << "(conversation LIKE ? OR conversation LIKE ?)"

    values << "%#{date}%"
    values << "%Posted: #{date}%"

  end

  @jmleads = @jmleads.where(
    conditions.join(" OR "),
    *values
  )


when "month"

  conditions = []
  values = []

  (Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).each do |day|

    date = day.strftime("%d %b %Y")

    conditions << "(conversation LIKE ? OR conversation LIKE ?)"

    values << "%#{date}%"
    values << "%Posted: #{date}%"

  end

  @jmleads = @jmleads.where(
    conditions.join(" OR "),
    *values
  )


when "date"

  if params[:date].present?

    day = Date.parse(params[:date]) rescue nil

    if day

      date = day.strftime("%d %b %Y")

      @jmleads = @jmleads.where(
        "conversation LIKE ? OR conversation LIKE ?",
        "%#{date}%",
        "%Posted: #{date}%"
      )

    end

  end

end


# ============================================
# FILTER BY UNCONTACTED DATE
#
# When a user clicks a date card, show only
# uncontacted leads from that date.
#
# Includes OPEN + CONVERTED.
# ============================================

if params[:uncontacted_date].present?

  date = Date.parse(params[:uncontacted_date]) rescue nil

  if date

    @jmleads = Jmlead.uncontacted
                     .where(
                       last_customer_message_at: date.all_day
                     )
                     .order(
                       last_customer_message_at: :desc
                     )
                     .page(params[:page])
                     .per(per_page)

  end

end

  # ==================================================
  # ORDER
  # ==================================================

  @jmleads = @jmleads
               .order(updated_at: :desc)
               .page(params[:page])
               .per(per_page)

  # ==================================================
  # COUNTS
  # ==================================================

  @total_leads      = Jmlead.count
  @converted_count  = Jmlead.where(status: "converted").count


  @open_count  = @moses ? Jmlead.where(status: "open", jstaff_id: @moses.id).count : 0
  @openj_count = @janet ? Jmlead.where(status: "open", jstaff_id: @janet.id).count : 0
  @dsa_count   = @dsa ? Jmlead.where(status: "open", jstaff_id: @dsa.id).count : 0

@uncontacted_count = Jmlead.uncontacted.count

  # ==================================================
  # OVERALL CONVERSION %
  # ==================================================

  @conversion_rate =
    if @total_leads.zero?
      0
    else
      ((@converted_count.to_f / @total_leads) * 100).round(1)
    end

  # ==================================================
  # STAFF CONVERSION %
  # ==================================================

  @moses_conversion = staff_conversion(@moses)
  @janet_conversion = staff_conversion(@janet)
  @dsa_conversion   = staff_conversion(@dsa)

  respond_to do |format|
    format.html

    format.csv do
      send_data Jmlead.to_csv({}, @jmleads),
                filename: "jmleads_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
    end

    format.xlsx do
      render xlsx: "data",
             filename: "jmleads_#{Time.current.strftime('%Y%m%d_%H%M%S')}.xlsx"
    end

    format.js
  end
end


def send_whatsapp
  @jmlead = Jmlead.find(params[:id])

  message = params[:message].to_s.strip

  if message.blank?
    redirect_to jmlead_path(@jmlead),
                alert: "Message cannot be empty."
    return
  end

  # ==========================================
  # PHONE
  # ==========================================

  phone = @jmlead.phone.to_s.strip

  if phone.blank?
    redirect_to jmlead_path(@jmlead),
                alert: "Customer has no phone number."
    return
  end

  # ==========================================
  # FIND AI CUSTOMER
  # ==========================================

  customer =
    Aicustomer.find_or_create_by!(
      phone: phone
    )

  # ==========================================
  # FIND CONVERSATION
  # ==========================================

  conversation =
    customer.aiconversations.last ||
    customer.aiconversations.create!

  # ==========================================
  # SEND TO CUSTOMER WHATSAPP
  # ==========================================

  response =
    WhatsappService.send_message(
      phone,
      message
    )

  unless response.success?

    Rails.logger.error(
      "[Manual WhatsApp] Failed sending to #{phone}: #{response.body}"
    )

    redirect_to jmlead_path(@jmlead),
                alert: "WhatsApp message failed."
    return
  end

  # ==========================================
  # SAVE HUMAN AGENT MESSAGE
  # ==========================================

  conversation.aimessages.create!(
    role: "staff",
    phone: phone,
    message_type: "text",
    content: message
  )

  Rails.logger.info(
    "[Manual WhatsApp] Staff message sent to #{phone}: #{message}"
  )

  # ==========================================
  # REDIRECT
  # ==========================================

  redirect_to jmlead_path(@jmlead),
              notice: "WhatsApp message sent successfully."

rescue => e

  Rails.logger.error(
    "[Manual WhatsApp] #{e.class}: #{e.message}"
  )

  Rails.logger.error(
    e.backtrace.join("\n")
  )

  redirect_to jmlead_path(@jmlead),
              alert: "Unable to send WhatsApp message."

end


def conversation
  @jmlead = Jmlead.find(params[:id])

  respond_to do |format|
    format.html do
      render partial: "jmleads/conversation",
             locals: { jmlead: @jmlead },
             layout: false
    end
  end
end

  # GET /jmleads/1 or /jmleads/1.json
 def show
  @jmlead = Jmlead.find(params[:id])
  @audits = Audited::Audit.where(auditable: @jmlead).order(created_at: :desc)
end

# PATCH /jmleads/:id/add_comment
def add_comment
  @jmlead = Jmlead.find(params[:id])

  conversation = params[:jmlead][:conversation].to_s.strip

  if conversation.present?

    entry = <<~TEXT.strip
      Customer:
      [#{Time.current.in_time_zone("Africa/Nairobi").strftime("%d %b %Y %I:%M %p")}]
      #{conversation}
    TEXT

    @jmlead.conversation = [
      @jmlead.conversation.presence,
      entry
    ].compact.join("\n\n")

    # ✅ Customer Care has handled the latest customer message
    @jmlead.last_handled_at = Time.current

    if @jmlead.save
      redirect_to jmlead_path(@jmlead),
                  notice: "Conversation added successfully."
    else
      redirect_to jmlead_path(@jmlead),
                  alert: "Failed to add conversation."
    end

  else

    redirect_to jmlead_path(@jmlead),
                alert: "Conversation cannot be blank."

  end
end

  # GET /jmleads/new
  def new
    @jmlead = Jmlead.new
  end

  # GET /jmleads/1/edit
  def edit
  end

# POST /jmleads or /jmleads.json
def create
  phone = jmlead_params[:phone]

  # 🔍 Normalize phone to match Jmcustomer and Jmlead formats
  normalized_phone = phone.to_s.strip

  # 1️⃣ Check if a lead already exists with this phone
  existing_lead = Jmlead.find_by(phone: normalized_phone)

  if existing_lead.present?
    if existing_lead.converted?
      # 2️⃣ Lead already converted → redirect to the customer linked to it
      customer = existing_lead.jmcustomer

      if customer
        flash[:alert] = "This lead was already converted to a customer. Redirected to customer page."
        redirect_to jmcustomer_path(customer, turbo: false) and return
      else
        flash[:alert] = "Lead converted but customer record not found."
        redirect_to jmleads_path and return
      end
    else
      # 3️⃣ Lead exists and is still open → go to show page
      flash[:notice] = "Lead already exists. Opening lead page."
      redirect_to jmlead_path(existing_lead, turbo: false) and return
    end
  end

  # 4️⃣ Lead does NOT exist → create new lead
  @jmlead = Jmlead.new(jmlead_params)

  if @jmlead.save
    redirect_to @jmlead, notice: "Lead created successfully."
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /jmleads/1 or /jmleads/1.json
  def update
    respond_to do |format|
      if @jmlead.update(jmlead_params)
        format.html { redirect_to @jmlead, notice: "Jmlead was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @jmlead }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jmlead.errors, status: :unprocessable_entity }
      end
    end
  end


      def search
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @jmleads = Jmlead.none.page(params[:page]).per(20)
      flash.now[:alert] = "No search criteria provided."
    else
      @c = Jmlead.ransack(params[:q])
      @jmleads = @c.result.order(updated_at: :desc).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @jmleads.to_csv, filename: "customers-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
    end
  end

  # DELETE /jmleads/1 or /jmleads/1.json
  def destroy
    @jmlead.destroy!

    respond_to do |format|
      format.html { redirect_to jmleads_path, notice: "Jmlead was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

private

def open_leads_count(name)
  staff = Jstaff.find_by(name: name)
  return 0 unless staff

  Jmlead.where(status: "open", jstaff_id: staff.id).count
end
    # Use callbacks to share common setup or constraints between actions.
   def set_jmlead
  @jmlead = Jmlead.includes(:jmcustomer, :jstaff).find(params[:id])
  @jmcustomer = @jmlead.jmcustomer
end

   # Only allow a list of trusted parameters through.
def jmlead_params
  params.require(:jmlead).permit(
    :name,
    :phone,
    :items_required,
    :status,
    :sglid,
    :jstaff_id,        # assigned_to
    :general_comments,
    :comments,
    :conversation

  )
end



  def open_leads_count(name)
  staff = Jstaff.find_by(name: name)
  staff ? Jmlead.where(status: "open", jstaff_id: staff.id).count : 0
end


def staff_conversion(staff)
  return 0 unless staff

  total = Jmlead.where(jstaff_id: staff.id).count
  return 0 if total.zero?

  converted = Jmlead.where(
    jstaff_id: staff.id,
    status: "converted"
  ).count

  ((converted.to_f / total) * 100).round(1)
end


# ✅ Send Thank-You SMS
def send_thank_you_sms(lead)
  return unless lead.phone.present?



  sms_service = TextsmsService.new(
    api_key: ENV.fetch("TEXTSMS_API_KEY"),
    partner_id: ENV.fetch("TEXTSMS_PARTNER_ID"),
    shortcode: "JANOMAX"
  )
  sql = lead.sqlid.to_s

  first_name = lead.name.to_s.strip.split.first
  message = "Dear #{first_name}, thank you for choosing Janomax Premium Bales. We truly appreciate your trust and support. Your call has been recorded and booked under #{sql}."

  response = sms_service.send_sms(lead.phone, message)

  Rails.logger.info("[#{sql}] Thank-you SMS sent to #{lead.phone}: #{response}")


rescue => e
  Rails.logger.error("[#{sql}] SMS failed for #{lead.phone}: #{e.message}")
end


end
