class JmcallcommentsController < ApplicationController
  before_action :set_customer

  def create
    @comment = @jmcustomer.jmcallcomments.create(comment_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @jmcustomer }
    end
  end

  private

  def set_customer
    @jmcustomer = Jmcustomer.find(params[:jmcustomer_id])
  end

  def comment_params
    params.require(:jmcallcomment).permit(:comment)
  end
end