class HomeController < ApplicationController
  def index
    Rails.logger.info "✅ Home#index reached"

    respond_to do |format|
      format.html
      format.js
    end
  end
end