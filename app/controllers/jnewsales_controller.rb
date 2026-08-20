class JnewsalesController < ApplicationController
  before_action :set_jnewsale, only: %i[ show edit update destroy ]

  # GET /jnewsales or /jnewsales.json
   def index
@jnewsales = Jnewsale
               .order(created_at: :desc)
               .page(params[:page])
               .per(50)


  end



  # GET /jnewsales/1 or /jnewsales/1.json
  def show
  end



  # GET /jnewsales/1/edit
  def edit
  end

  BRANCHES = ["Nairobi", "Mombasa", "Kitale", "Eldoret", "Kisumu", "Naks", "Kisii", "Meru","BGM","HH","Warehouse"]


def new
  # Only branches that currently have stock
  @branches = Jstock
                .where("qty > 0")
                .group(:branch)
                .order(Arel.sql("SUM(qty) DESC"))
                .pluck(:branch)

  @selected_branch = params[:branch].presence || @branches.first

  # Only bales with stock in the selected branch
  @bales = Jstock
             .where(branch: @selected_branch)
             .where("qty > 0")
             .group(:bale_name)
             .order(Arel.sql("LOWER(bale_name) ASC"))
             .pluck(:bale_name)

  @jnewsale = Jnewsale.new

  # Stock map for selected branch
@stock_hash = Jstock
                .where(branch: @selected_branch)
                .where("qty > 0")
                .pluck(:bale_name, :branch, :qty)
                .each_with_object({}) do |(bale, branch, qty), hash|
  hash[bale] ||= {}
  hash[bale][branch] = qty
end

  # Today's sales
 @today_sales = Jnewsale
                 .select(:id, :bale_name, :branch, :qty, :selling_price, :created_at)
                 .where(branch: @selected_branch)
                 .where(created_at: Time.zone.today.all_day)

  # Yesterday's sales
@yesterday_sales = Jnewsale
                     .select(:id, :bale_name, :branch, :qty, :selling_price, :created_at)
                     .where(branch: @selected_branch)
                     .where(created_at: 1.day.ago.all_day)

  # Qty reduction audits
# Qty reduction audits
@audits = Audited::Audit
            .includes(:auditable, :user)
            .where(auditable_type: "Jstock")
            .order(created_at: :desc)
            .limit(300)
            .select do |audit|
              qty_change = audit.audited_changes["qty"]

              qty_change.is_a?(Array) &&
                qty_change[1].to_i < qty_change[0].to_i
            end
            .first(50)
end


def create
  sales_hash = params[:sales] || {}

  ActiveRecord::Base.transaction do
    sales_hash.each do |bale, branches|
      branches.each do |branch, qty|
        qty = qty.to_i
        next if qty <= 0

        stock = Jstock.find_by(
          "LOWER(TRIM(bale_name)) = ? AND LOWER(TRIM(branch)) = ?",
          bale.strip.downcase,
          branch.strip.downcase
        )

        raise "Stock not found for #{bale} (#{branch})" unless stock

        if stock.qty < qty
          raise "Only #{stock.qty} bale(s) of #{bale} available at #{branch}."
        end

        # If stock comes from HH, record the sale under Nairobi
        sale_branch = stock.branch == "HH" ? "Nairobi" : stock.branch

        # Create sale
        Jnewsale.create!(
          bale_name: stock.bale_name,
          branch: sale_branch,
          qty: qty,
          selling_price: stock.selling_price
        )

        # Update branch performance
        performance = Jbranchperformance.find_or_initialize_by(
          branch: sale_branch,
          record_date: Date.current
        )

        performance.bales_sold ||= 0
        performance.bales_sold += qty
        performance.save!

        # Reduce stock
        stock.decrement!(:qty, qty)
      end
    end
  end

  # ------------------------------------------
  # REFRESH BALES PREDICTION IN BACKGROUND
  # ------------------------------------------
  BalesPredictionJob.perform_later

  redirect_to new_jnewsale_path(branch: params[:branch]),
              notice: "Sales saved successfully!"

rescue => e
  Rails.logger.error "[Jnewsales#create] #{e.class}: #{e.message}"
  Rails.logger.error e.backtrace.first(10).join("\n")

  redirect_to new_jnewsale_path(branch: params[:branch]),
              alert: e.message
end

def search
  @jnewsale = Jnewsale.new

  @branches = Jstock::BRANCHES
  @selected_branch = params[:branch].presence || @branches.first

  @n = Jnewsale.ransack(params[:q])

  if params[:q].blank? || params[:q].values.all?(&:blank?)
    @jnewsales = Jnewsale.none
    @bales = []
    flash.now[:alert] = "No search criteria provided."
  else
    @jnewsales = @n.result
                   .where(branch: @selected_branch)
                   .order(created_at: :desc)

    @bales = @jnewsales.pluck(:bale_name).uniq.sort
  end

@stock_hash = Jstock
                .where(branch: @selected_branch)
                .where("qty > 0")
                .pluck(:bale_name, :branch, :qty)
                .each_with_object({}) do |(bale, branch, qty), hash|
  hash[bale] ||= {}
  hash[bale][branch] = qty
end

@today_sales = Jnewsale
                 .select(:id, :bale_name, :branch, :qty, :selling_price, :created_at)
                 .where(branch: @selected_branch)
                 .where(created_at: Time.zone.today.all_day)

@yesterday_sales = Jnewsale
                     .select(:id, :bale_name, :branch, :qty, :selling_price, :created_at)
                     .where(branch: @selected_branch)
                     .where(created_at: 1.day.ago.all_day)

@audits = Audited::Audit
            .includes(:auditable, :user)
            .where(auditable_type: "Jstock")
            .order(created_at: :desc)
            .limit(500)
            .select do |audit|
              changes = audit.audited_changes
              next false unless changes.is_a?(Hash)

              qty_change = changes["qty"]
              next false unless qty_change.is_a?(Array)
              next false unless qty_change.size == 2
              next false unless qty_change[1].to_i < qty_change[0].to_i

              audit.auditable.present? &&
                audit.auditable.branch == @selected_branch
            end
            .first(100)

  render :new
end

  # PATCH/PUT /jnewsales/1 or /jnewsales/1.json
  def update
    respond_to do |format|
      if @jnewsale.update(jnewsale_params)
        format.html { redirect_to @jnewsale, notice: "Jnewsale was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @jnewsale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jnewsale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jnewsales/1 or /jnewsales/1.json
  def destroy
    @jnewsale.destroy!

    respond_to do |format|
      format.html { redirect_to jnewsales_path, notice: "Jnewsale was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jnewsale
      @jnewsale = Jnewsale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jnewsale_params
      params.require(:jnewsale).permit(:bale_name, :branch, :qty, :selling_price, :amount, :note)
    end
end
