require "open-uri"

class ApplicationController < ActionController::Base
  around_action :log_request
  before_action :set_customer_care_count

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_ransack

  after_action :sync_login_history

  helper_method :pending_approvals_count

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: "Access denied."
  end

  protected

  # =====================================
  # DEVISE
  # =====================================

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :username,
        :email,
        :phone_number,
        :userdetails
      ]
    )

    devise_parameter_sanitizer.permit(
      :sign_in,
      keys: [
        :login,
        :username,
        :password
      ]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :username,
        :email,
        :phone_number,
        :password,
        :password_confirmation,
        :current_password,
        :userdetails
      ]
    )
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_update_path_for(resource)
    root_path
  end



    # =====================================
  # APPROVALS
  # =====================================

  def pending_approvals_count
    MApproval.where(status: "pending").count
  end

  # =====================================
  # THEME
  # =====================================

  def set_theme
    return unless params[:theme].present?

    new_theme = params[:theme].to_s
    return if cookies[:theme] == new_theme

    cookies[:theme] = {
      value: new_theme,
      expires: 1.year.from_now
    }

    # No redirect needed.
    # The cookie will be available on the next request.
  end

  # =====================================
  # LOGIN HISTORY
  # =====================================

  def sync_login_history
    return unless user_signed_in?
    return if session[:login_history_id].blank?

    begin
      login_session = current_user
                        .login_sessions
                        .find(session[:login_history_id])

      login_session.update(
        session_id: session.id,
        status: "active"
      )
    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn("Login session not found")
    end
  end

  # =====================================
  # GLOBAL RANSACK
  # =====================================

  def set_ransack


    @j = Janomax.ransack(params[:q_j])
    @janomaxes = @j.result(distinct: true)

    @y = Jmcustomer.ransack(params[:q_y])
    @jmcustomers = @y.result(distinct: true)

    @f = Jmcustomer.ransack(params[:q_f])
    @jfulfillments = @f.result(distinct: true)



    @c = Jmlead.ransack(params[:q_c])
    @jmleads = @c.result(distinct: true)


    @js = Jsample.ransack(params[:q_js])
    @jsamples = @js.result(distinct: true)



    @cp = Jmpayment.ransack(params[:q_cp])
    @jmcustomerpayments = @cp.result(distinct: true)
  end

  
  # =====================================
  # REQUEST LOGGING
  # =====================================

  def log_request
    start_time = Time.current

    yield

  rescue => e
    Rails.logger.error "🔥 ERROR: #{e.message}"
    Rails.logger.error(
      e.backtrace.select { |line| line.include?("/app/") }.first(10)
    )

    raise e

  ensure
    duration = ((Time.current - start_time) * 1000).to_i

    begin
      RequestLog.create(
        path: request.fullpath,
        method: request.request_method,
        status: response.status || 500,
        duration: duration,
        ip: request.remote_ip,
        user_id: current_user&.id
      )
    rescue => log_error
      Rails.logger.error "⚠️ RequestLog failed: #{log_error.message}"
    end
  end

  private

    def set_customer_care_count
    @customer_care_count =
      Jfulfillment
        .where(
          feedback: "negative",
          issue_status: "pending"
        )
        .count
  end

  # =====================================
  # SMS BALANCE
  # =====================================

  def check_sms_balance
    sms_service = TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    )

    balance_result = sms_service.balance

    return if balance_result.is_a?(Hash) && balance_result["error"]

    @sms_balance = balance_result.to_i

    alert_level =
      if @sms_balance < 19
        19
      elsif @sms_balance < 49
        49
      elsif @sms_balance < 99
        99
      end

    return unless alert_level

    cache_key = "sms_balance_alert_#{alert_level}"

    unless Rails.cache.exist?(cache_key)
      sms_service.send_sms(
        "254714316282",
        "⚠️ Janomax SMS balance is #{@sms_balance}. Kindly top up immediately. Balance has fallen below #{alert_level} SMS credits."
      )

      Rails.cache.write(cache_key, true, expires_in: 24.hours)
    end
  end
end