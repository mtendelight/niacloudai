# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  #before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  #skip_before_action :verify_authenticity_token, :only => :create
  # GET /resource/sign_up
  # def new
  #   super
  # end
 @enable_turbo = true
 before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Add additional parameters to the sign up and account update forms
  def configure_permitted_parameters
    # Permit parameters for user registration
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :phone_number])

    # Permit parameters for user account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :phone_number])
  end

  # POST /resource

#def create
 # super do |user|
 #   UserSession.create(user_id: user.id, device: request.user_agent, last_sign_in_at: user.current_sign_in_at, last_sign_in_ip: user.current_sign_in_ip)
 # end
#end
  # GET /resource/edit
  # def edit
  #   super
  # end

protected
 def after_update_path_for(resource)
    # Customize the redirect path here
    
     "/"
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
