class JfulfillmentsController < ApplicationController
  before_action :set_jfulfillment, only: %i[ show edit update destroy ]
before_action :authenticate_user!, only: [:new, :edit]
  # GET /jfulfillments or /jfulfillments.json
# GET /jfulfillments
  def index
    check_sms_balance
    per_page = (params[:per_page] || 5).to_i

    # Eager load customers to avoid N+1
    @jfulfillments = Jfulfillment.order(created_at: :desc)
                            .page(params[:page])
                            .per(per_page)


    @jfulfillments1 = Jfulfillment.where.not(status: ["refunded", "delivered"])


    respond_to do |format|
      format.html
      format.csv do
        filename = "jfulfillments_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
        send_data Jfulfillment.to_csv(@jfulfillments), filename: filename
      end
      format.xlsx do
        filename = "jfulfillments_#{Time.current.strftime('%Y%m%d_%H%M%S')}.xlsx"
        render xlsx: 'index', filename: filename
      end
      format.js
    end
  end

    def mark_all_delivered
    updated = Jfulfillment
                .where(status: ["Pending", "Dispatched"])
                .update_all(
                  status: "Delivered",
                  updated_at: Time.current
                )

    redirect_to jfulfillments_path,
                notice: "#{updated} fulfillment records marked as Delivered."
  end


  # GET /jfulfillments/pending
    def pending
      @jfulfillments = Jfulfillment.where(status: "pending").order(created_at: :asc).page(params[:page]).per(10)
      render :index
    end

def customer_care
  @jfulfillments = Jfulfillment.where(feedback: "negative", issue_status: "pending")
                               .order(created_at: :desc)
                               .page(params[:page])
                               .per(5)
  render :index
end

    # GET /jfulfillments/dispatched
# GET /jfulfillments/dispatched
def dispatched
  @jfulfillments = Jfulfillment.where(status: "dispatched")
                               .order(created_at: :asc)
                               .page(params[:page])
                               .per(5)
  render :index
end

  # GET /jfulfillments/delivered
def delivered
  @jfulfillments = Jfulfillment.where(status: "delivered")
                                .order(created_at: :desc)
                                .page(params[:page])
                                .per(5)
  @disable_edit = true   # disable editing for delivered
  render :index
end


    # GET /jfulfillments/refund_cancelled
    def refund_cancelled
      @jfulfillments = Jfulfillment.where(status: "refund_cancelled").order(created_at: :desc).page(params[:page]).per(10)
      render :index
    end

    # GET /jfulfillments/refunded
  def refunded
    @jfulfillments = Jfulfillment.where(status: "refunded")
                                  .order(created_at: :desc)
                                  .page(params[:page])
                                  .per(5)
    @disable_edit = true   # flag to disable editing in view
    render :index
  end
  # GET /jfulfillments/1 or /jfulfillments/1.json
 # GET /jfulfillments/1
def show
  @jfulfillment = Jfulfillment.includes(:jmcustomer).find(params[:id])
  @audits = @jfulfillment.audits.includes(:user).order(created_at: :desc)
end

def fulfillment_summary
  start_date = Date.current.beginning_of_month
  end_date   = Date.current.end_of_month

  @user_summary = Audited::Audit
                    .includes(:user)
                    .where(auditable_type: "Jfulfillment")
                    .where(created_at: start_date..end_date)
                    .group_by(&:user)
end

def performance
  start_date = Date.current.beginning_of_month
  end_date   = Date.current.end_of_month

  @user_summary = {}

  # Initialize all managers and superadmins
  User.joins(:roles)
      .where(roles: { name: %w[manager superadmin] })
      .distinct
      .each do |user|
    @user_summary[user.id] = {
      user: user,
      dispatched: 0,
      delivered: 0,
      refunded: 0,
      total: 0
    }
  end

  Audited::Audit
    .includes(:user)
    .where(auditable_type: "Jfulfillment")
    .where(created_at: start_date..end_date)
    .find_each do |audit|

    next unless audit.user
    next unless @user_summary.key?(audit.user.id)
    next unless audit.audited_changes["status"].present?

    from_status, to_status = audit.audited_changes["status"]

    case to_status
    when "Dispatched"
      @user_summary[audit.user.id][:dispatched] += 1
    when "Delivered"
      @user_summary[audit.user.id][:delivered] += 1
    when "Refunded", "Refund/Cancelled"
      @user_summary[audit.user.id][:refunded] += 1
    end

    @user_summary[audit.user.id][:total] += 1
  end
end
  # GET /jfulfillments/new
  def new
    @jfulfillment = Jfulfillment.new
  end

  # GET /jfulfillments/1/edit
  def edit
      @jfulfillment = Jfulfillment.includes(:jmcustomer).find(params[:id])
      @audits = @jfulfillment.audits.includes(:user).order(created_at: :desc)
  end

  # POST /jfulfillments or /jfulfillments.json
  def create
    @jfulfillment = Jfulfillment.new(jfulfillment_params)

    respond_to do |format|
      if @jfulfillment.save
        format.html { redirect_to @jfulfillment, notice: "Jfulfillment was successfully created." }
        format.json { render :show, status: :created, location: @jfulfillment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jfulfillment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jfulfillments/1 or /jfulfillments/1.json
def update
  if @jfulfillment.update(jfulfillment_params)
    respond_to do |format|
      format.html do
        redirect_to customer_care_jfulfillments_path,
                    notice: "Jfulfillment was successfully updated.",
                    status: :found   # 302 → Turbo-friendly
      end

      format.json do
        render :show, status: :ok, location: @jfulfillment
      end
    end
  else
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @jfulfillment.errors, status: :unprocessable_entity }
    end
  end
end




  def search
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @jfulfillments = Jfulfillment.none.page(params[:page]).per(10)
      flash.now[:alert] = "No search criteria provided."
    else
      @f = Jfulfillment.ransack(params[:q])
      @jfulfillments = @f.result.order(updated_at: :desc).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @jmfulfillments.to_csv, filename: "customers-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
    end
  end



  # DELETE /jfulfillments/1 or /jfulfillments/1.json
  def destroy
    @jfulfillment.destroy!

    respond_to do |format|
      format.html { redirect_to jfulfillments_path, notice: "Jfulfillment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jfulfillment
      @jfulfillment = Jfulfillment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
   def jfulfillment_params
  params.require(:jfulfillment).permit(
    :issue_status,
    :name,
    :phone,
    :location,
    :items,
    :status,
    :feedback,
    :comments,
    :jmcustomer_id,
    :transaction_ref,
    :jorder_id
  )
end
end
