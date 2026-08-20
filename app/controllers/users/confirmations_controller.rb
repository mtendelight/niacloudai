# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  # You may want to uncomment and customize this if you need to handle custom behavior after resending confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # You may want to uncomment and customize this if you need to handle custom behavior after confirmation
  # def show
  #   super
  # end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    new_user_confirmation_path # Adjust this path as needed for your application
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource) # Customize this if needed
  end
end
