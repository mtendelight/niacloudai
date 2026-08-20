class JbranchperformancesController < ApplicationController
  before_action :set_jbranchperformance, only: %i[ show edit update destroy ]

 

def index
  today = Date.current
  prev_month  = today.prev_month
  prev2_month = today.prev_month.prev_month

  # -------------------------------
  # NORMALIZED DAYS (CRITICAL FIX)
  # -------------------------------
  @days = (1..today.end_of_month.day).to_a

  def build_series(days, base_date, data)
    days.map do |day|
      date = base_date.beginning_of_month + (day - 1).days
      data[date] || 0
    end
  end

  def cumulative(arr)
    arr.inject([]) { |sum, x| sum << (sum.last || 0) + x }
  end

  # -------------------------------
  # DAILY DATA (ALL 3 MONTHS)
  # -------------------------------

  current_daily = Jbranchperformance
    .where(record_date: today.beginning_of_month..today.end_of_month)
    .group(:record_date)
    .sum(:bales_sold)

  previous_daily = Jbranchperformance
    .where(record_date: prev_month.beginning_of_month..prev_month.end_of_month)
    .group(:record_date)
    .sum(:bales_sold)

  prev2_daily = Jbranchperformance
    .where(record_date: prev2_month.beginning_of_month..prev2_month.end_of_month)
    .group(:record_date)
    .sum(:bales_sold)

  # -------------------------------
  # SERIES (ALIGNED LENGTHS)
  # -------------------------------

  @current_series  = build_series(@days, today, current_daily)
  @previous_series = build_series(@days, prev_month, previous_daily)
  @prev2_series    = build_series(@days, prev2_month, prev2_daily)

  # -------------------------------
  # CUMULATIVE
  # -------------------------------

  @current_cumulative  = cumulative(@current_series)
  @previous_cumulative = cumulative(@previous_series)
  @prev2_cumulative    = cumulative(@prev2_series)

  # -------------------------------
  # BASIC METRICS
  # -------------------------------

  @today = today
  @yesterday = 1.day.ago.to_date
 @today_performance = Jbranchperformance.where(record_date: @today)
  @today_total = Jbranchperformance.where(record_date: @today).sum(:bales_sold)
  @yesterday_total = Jbranchperformance.where(record_date: @yesterday).sum(:bales_sold)

  # -------------------------------
  # MONTHLY TOTALS (BRANCH)
  # -------------------------------

  @current_month = Jbranchperformance
    .where(record_date: today.beginning_of_month..today.end_of_month)
    .group(:branch)
    .sum(:bales_sold)

  @previous_month = Jbranchperformance
    .where(record_date: prev_month.beginning_of_month..prev_month.end_of_month)
    .group(:branch)
    .sum(:bales_sold)

  # -------------------------------
  # PIVOT TABLE
  # -------------------------------

  @year = params[:year]&.to_i || today.year
  @months = Date::MONTHNAMES.compact
  @branches = Jbranchperformance::BRANCHES

  @pivot_data = @months.map.with_index(1) do |month, idx|
    row = { month: month }

    @branches.each do |branch|
      row[branch] = Jbranchperformance
        .where(branch: branch)
        .where(record_date: Date.new(@year, idx, 1)..Date.new(@year, idx, -1))
        .sum(:bales_sold)
    end

    row
  end






# ==========================================
# HIGH VALUE STOCK ANALYSIS
# ==========================================

@high_value_stock = Jstock
  .where("amount > ?", 75_000)
  .group_by(&:bale_name)
  .map do |bale_name, stocks|

    OpenStruct.new(
      bale_name: bale_name,

      branches: stocks.map(&:branch).uniq.join(", "),

      total_qty: stocks.sum(&:qty),

      total_amount: stocks.sum(&:amount),

      selling_price: stocks.map(&:selling_price).compact.max
    )

  end
  .sort_by { |s| -s.total_amount.to_f }

# ==========================================
# CSV EXPORT
# ==========================================

respond_to do |format|

  format.html

  format.csv do

    headers["Content-Disposition"] =
      "attachment; filename=high_value_inventory_#{Date.today}.csv"

    headers["Content-Type"] = "text/csv"

    csv_data = CSV.generate(headers: true) do |csv|

      csv << [
        "#",
        "Item",
        "Branches",
        "Total Qty",
        "Highest Selling Price",
        "Total Holding Value"
      ]

      @high_value_stock.each_with_index do |stock, index|

        csv << [
          index + 1,
          stock.bale_name,
          stock.branches,
          stock.total_qty,
          stock.selling_price,
          stock.total_amount
        ]

      end

      csv << []

      csv << [
        "",
        "TOTALS",
        "",
        @high_value_stock.sum(&:total_qty),
        "",
        @high_value_stock.sum(&:total_amount)
      ]

    end

    render plain: csv_data

  end

end





# ACTIVE MONTHS
# -------------------------------
@monthly_totals = @pivot_data.map do |row|
  @branches.sum { |b| row[b] || 0 }
end

@active_month_indexes = @monthly_totals.each_index.select do |i|
  @monthly_totals[i] > 0
end

@active_months = @active_month_indexes.map { |i| @months[i] }

# -------------------------------
# ACTIVE BRANCHES (ANY DATA IN ANY MONTH)
# -------------------------------
@active_branches = @branches.select do |branch|
  @pivot_data.any? { |row| (row[branch] || 0) > 0 }
end


monthly_totals = @pivot_data.map do |row|
  @branches.sum { |b| row[b].to_f }
end

active_months = monthly_totals.select { |t| t > 0 }

@active_months_count = active_months.size

@overall_monthly_avg =
  if active_months.any?
    active_months.sum.to_f / active_months.size
  else
    0
  end

current_month_total =
  @branches.sum { |b| @current_month[b].to_f }

previous_month_total =
  @branches.sum { |b| @previous_month[b].to_f }

@growth_rate =
  if previous_month_total > 0
    (((current_month_total - previous_month_total) / previous_month_total) * 100).round(2)
  else
    0
  end

# =====================================================
# TOP SELLING BALES - LAST 4 MONTHS (FIXED ENGINE)
# =====================================================

today = Date.current

months = (0..3).map { |i| today.prev_month(i) }.reverse

monthly_data = months.map do |date|
  [
    date.strftime("%Y-%m"),
    Jnewsale
      .where(created_at: date.beginning_of_month..date.end_of_month)
      .group(:bale_name)
      .sum(:qty)
  ]
end.to_h

all_bales = monthly_data.values.flat_map(&:keys).uniq

analytics = all_bales.map do |bale|

  monthly_sales = months.map do |date|
    key = date.strftime("%Y-%m")
    monthly_data.dig(key, bale).to_i
  end

  current_sales  = monthly_sales.last
  previous_sales = monthly_sales[-2] || 0

  stock = Jstock.where(bale_name: bale).sum(:qty)

  revenue = Jnewsale
    .where(bale_name: bale)
    .where(created_at: months.first.beginning_of_month..today.end_of_month)
    .sum(:amount)

  growth = if previous_sales > 0
    ((current_sales - previous_sales).to_f / previous_sales * 100).round(1)
  elsif current_sales > 0
    100
  else
    0
  end

  avg_sales = (monthly_sales.sum / 4.0).round(2)

  turnover = stock > 0 ? (avg_sales / stock).round(2) : 0

  days_to_sell = avg_sales > 0 ? ((stock / avg_sales.to_f) * 30).round : 999

  risk =
    if stock > avg_sales * 3
      "HIGH"
    elsif stock > avg_sales * 1.5
      "MEDIUM"
    else
      "LOW"
    end

  {
    bale: bale,
    monthly_sales: monthly_sales,
    current: current_sales,
    previous: previous_sales,
    avg_sales: avg_sales,
    growth: growth,
    stock: stock,
    revenue: revenue,
    turnover: turnover,
    days_to_sell: days_to_sell,
    risk: risk
  }
end

# ---------------------------------
# SAFE MONTH BUILDER FUNCTION
# ---------------------------------

def monthly_bales(date)
  Jnewsale
    .where(created_at: date.beginning_of_month..date.end_of_month)
    .group(:bale_name)
    .sum(:qty)
end

# ---------------------------------
# RAW HASHES (NO SORT YET)
# ---------------------------------

@current_month_bales = monthly_bales(today)
@last_month_bales    = monthly_bales(today.prev_month)
@prev2_month_bales   = monthly_bales(today.prev_month(2))
@prev3_month_bales   = monthly_bales(today.prev_month(3))

# ---------------------------------
# SORTED VERSIONS (ONLY FOR DISPLAY)
# ---------------------------------

@current_sorted = @current_month_bales.sort_by { |_, qty| -qty }
@last_sorted    = @last_month_bales.sort_by { |_, qty| -qty }
@prev2_sorted   = @prev2_month_bales.sort_by { |_, qty| -qty }
@prev3_sorted   = @prev3_month_bales.sort_by { |_, qty| -qty }

# =====================================================
# OPTIONAL: 4-MONTH CHART (UNCHANGED BUT CLEANER)
# =====================================================

current_month_index = today.month

month_indexes = (current_month_index - 3..current_month_index).to_a
month_indexes = month_indexes.map { |m| m <= 0 ? m + 12 : m }

@chart_data = @branches.map do |branch|

  data = month_indexes.map do |idx|

    year = idx > current_month_index ? today.year - 1 : today.year

    start_date = Date.new(year, idx, 1)
    end_date   = start_date.end_of_month

    [
      Date::MONTHNAMES[idx],
      Jbranchperformance
        .where(branch: branch)
        .where(record_date: start_date..end_date)
        .sum(:bales_sold)
    ]

  end

  { name: branch, data: data }

end

@chart_data = @chart_data.select do |series|
  series[:data].any? { |_, value| value > 0 }
end


end

  # GET /jbranchperformances/1 or /jbranchperformances/1.json
  def show
  end

def new
  @record_date = Date.today
  @branches = Jbranchperformance::BRANCHES
end

def create
  record_date = params[:record_date]

  ActiveRecord::Base.transaction do
    params[:branches].each do |branch, bales|
      Jbranchperformance.create!(
        branch: branch,
        bales_sold: bales,
        record_date: record_date
      )
    end
  end

  redirect_to jbranchperformances_path, notice: "Branch performance saved successfully"
rescue ActiveRecord::RecordInvalid => e
  redirect_to new_jbranchperformance_path, alert: e.message
end

  # GET /jbranchperformances/1/edit
  def edit
  end



  # PATCH/PUT /jbranchperformances/1 or /jbranchperformances/1.json
  def update
    respond_to do |format|
      if @jbranchperformance.update(jbranchperformance_params)
        format.html { redirect_to @jbranchperformance, notice: "Jbranchperformance was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @jbranchperformance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jbranchperformance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jbranchperformances/1 or /jbranchperformances/1.json
  def destroy
    @jbranchperformance.destroy!

    respond_to do |format|
      format.html { redirect_to jbranchperformances_path, notice: "Jbranchperformance was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jbranchperformance
      @jbranchperformance = Jbranchperformance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jbranchperformance_params
      params.require(:jbranchperformance).permit(:branch, :bales_sold, :record_date)
    end
end
