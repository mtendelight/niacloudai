class JbaleaiController < ApplicationController
  def index
     @branches = Jstock
                .where("qty > 0")
                .group(:branch)
                .order("SUM(qty) DESC")
                .pluck(:branch)
    @selected_branch = params[:branch].presence || @branches.first

    # =========================
    # DATA SOURCES
    # =========================
    sales = Jnewsale.where(branch: @selected_branch)
    stocks = Jstock.where(branch: @selected_branch)

    today_range = Time.zone.today.all_day

    # =========================
    # KPI METRICS
    # =========================
    @today_sales_qty = sales.where(created_at: today_range).sum(:qty)
    @today_revenue   = sales.where(created_at: today_range).sum(:amount)
    @stock_left      = stocks.sum(:qty)

    # =========================
    # PRE-CALCULATED GROUP DATA
    # =========================
    sales_by_bale   = sales.group(:bale_name).sum(:qty)
    sales_by_branch = Jnewsale.group(:branch).sum(:amount)

    # =========================
    # UI DATA
    # =========================
    @heatmap = sales_by_bale

    @top_bales = sales_by_bale
                  .sort_by { |_k, v| -v }
                  .first(5)

    @low_stock = stocks.where("qty <= ?", 3)

    @branch_rankings = sales_by_branch.sort_by { |_k, v| -v }

    # =========================
    # AI ENGINE
    # =========================
    @predictions = build_predictions(sales_by_bale)
    @reorder_list = build_reorder(stocks, sales_by_bale)
    @alerts = build_alerts(@low_stock, @predictions)
  end

  private

  # =========================
  # 📈 PREDICTION ENGINE
  # =========================
  def build_predictions(sales_by_bale)
    sales_by_bale.transform_values do |qty|
      (qty * 1.25).round
    end
  end

  # =========================
  # 📦 REORDER ENGINE
  # =========================
  def build_reorder(stocks, sales_by_bale)
    stocks.map do |stock|
      sold = sales_by_bale[stock.bale_name].to_i

      if stock.qty <= 3 || stock.qty < (sold * 0.2)
        {
          bale: stock.bale_name,
          stock: stock.qty,
          suggested: [(sold * 0.5).round, 10].max
        }
      end
    end.compact
  end

  # =========================
  # 🚨 ALERT ENGINE
  # =========================
  def build_alerts(low_stock, predictions)
    alerts = []

    low_stock.each do |item|
      alerts << "⚠️ #{item.bale_name}: only #{item.qty} left"
    end

    predictions.each do |bale, predicted|
      alerts << "🔥 High demand: #{bale} → #{predicted}" if predicted > 20
    end

    alerts
  end
end