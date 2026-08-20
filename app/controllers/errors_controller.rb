class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  layout false

  def not_found
    render template: "errors/not_found",
           status: :not_found,
           formats: [:html]
  end
end