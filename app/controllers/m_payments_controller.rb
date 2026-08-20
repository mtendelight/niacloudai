class MPaymentsController < ApplicationController
  before_action :set_subcontractor
  before_action :set_payment, only: [:show, :edit, :update, :destroy]


def index
  @m_payments = MPayment.includes(:m_approval).all
end
  # GET /m_subcontractors/:m_subcontractor_id/m_payments/new
  def new
    @m_payment = @m_subcontractor.m_payments.new
  end

  # POST /m_subcontractors/:m_subcontractor_id/m_payments
  def create
    @m_payment = @m_subcontractor.m_payments.new(m_payment_params)

    if @m_payment.save
      redirect_to m_subcontractor_m_payment_path(@m_subcontractor, @m_payment),
                  notice: "Payment was successfully recorded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /m_subcontractors/:m_subcontractor_id/m_payments/:id/edit
  def edit
  end

  # PATCH/PUT
  def update
    if @m_payment.update(m_payment_params)
      redirect_to m_subcontractor_m_payment_path(@m_subcontractor, @m_payment),
                  notice: "Payment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_subcontractor
    @m_subcontractor = MSubcontractor.find(params[:m_subcontractor_id])
  end

  def set_payment
    @m_payment = @m_subcontractor.m_payments.find(params[:id])
  end

def m_payment_params
  params.require(:m_payment).permit(
    :m_invoice_id,
    :amount,
    :payment_date,
    :method,
    :status,
    :file,
    :permit_public_id
  )
end
end