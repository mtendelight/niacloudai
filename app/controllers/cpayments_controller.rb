class CpaymentsController < ApplicationController
  before_action :set_contractor
  before_action :set_cpayment, only: [:show, :edit, :update, :destroy]

  def index
    @cpayments = @contractor.cpayments
  end

  def new
    @cpayment = @contractor.cpayments.build
  end

  def show
  @contractor = Contractor.find(params[:contractor_id])

  @payment = @contractor.cpayments
                        .includes(:cinvoice)
                        .find(params[:id])
end

  def create
    @cpayment = Cpayment.new(cpayment_params)

    if @cpayment.save
      redirect_to contractor_path(@contractor),
                  notice: "Payment recorded."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @cpayment.update(cpayment_params)
      redirect_to contractor_path(@contractor),
                  notice: "Payment updated."
    else
      render :edit
    end
  end

  def destroy
    @cpayment.destroy
    redirect_to contractor_path(@contractor),
                notice: "Payment deleted."
  end

  private

  def set_contractor
    @contractor = Contractor.find(params[:contractor_id])
  end

  def set_cpayment
    @cpayment = Cpayment.find(params[:id])
  end

  def cpayment_params
    params.require(:cpayment).permit(
      :cinvoice_id,
      :amount,
      :payment_date,
      :reference,
      :method,
      :notes
    )
  end
end