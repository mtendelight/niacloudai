class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json

def index
  per_page = (params[:per_page] || 5).to_i

  @bills = Bill.order(due_date: :asc)

  if params[:search].present?
    search = "%#{params[:search].strip}%"

    @bills = @bills.where(
      "title ILIKE :q OR
       category ILIKE :q OR
       payment_details ILIKE :q OR
       CAST(due_date AS TEXT) ILIKE :q",
      q: search
    )
  end

  @bills = @bills.page(params[:page]).per(per_page)

  # Summary Cards
  @total_monthly_bills = Bill.where(recurring: true).sum(:amount)
  @total_bills         = Bill.sum(:amount)
  @paid_bills          = Bill.where(paid: true).sum(:amount)
  @unpaid_bills        = Bill.where(paid: false).sum(:amount)

  @current_month_bills = Bill.where(
    due_date: Date.current.beginning_of_month..Date.current.end_of_month
  ).sum(:amount)
end

  # GET /bills/1 or /bills/1.json
  def show
  end

  # GET /bills/new
  def new
    @bill = Bill.new(due_date: Date.today.change(day: 5))
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: "Bill was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy!

    respond_to do |format|
      format.html { redirect_to bills_path, notice: "Bill was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.expect(bill: [ :title, :amount, :due_date, :paid, :category, :recurring, :payment_details ])
    end
end
