# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
before_action :authenticate_user!, only: [:destroy]
before_action :set_turbo, only: [:new, :create]



 #def destroy
  #super do |user|
  #user_session = UserSession.find_by(user_id: current_user.id)
  #user_session.destroy if user_session.present? 
 #end
 # end


  def destroy
    
    if user_signed_in? && usersession = UserSession.find_by(user_id: current_user.id).present?
  
 UserSession.find_by(user_id: current_user.id).destroy

    end
  super
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


   private

  def set_turbo
    @enable_turbo = false
  end
end
