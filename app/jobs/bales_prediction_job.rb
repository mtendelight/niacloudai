class BalesPredictionJob < ApplicationJob
  queue_as :default

  BRANCHES = [
    "Nairobi",
    "Mombasa",
    "Kitale",
    "Eldoret",
    "Kisumu",
    "Naks",
    "Kisii",
    "Meru",
    "BGM",
    "HH",
    "Warehouse"
  ].freeze

  CENTRAL_STOCK_BRANCHES = [
    "HH",
    "Warehouse"
  ].freeze

  CACHE_KEY = "bales_predictions:v2"

  def perform
    predictions = build_predictions

    Rails.cache.write(
      CACHE_KEY,
      predictions,
      expires_in: 12.hours
    )

    Rails.cache.write(
      "#{CACHE_KEY}:updated_at",
      Time.current,
      expires_in: 12.hours
    )

    Rails.logger.info(
      "[BalesPredictionJob] Generated #{predictions.size} predictions"
    )

    predictions
  end

  private

  def build_predictions
    today = Date.current
    current_month_start = today.beginning_of_month

    # ==================================================
    # LAST 6 MONTHS
    # ==================================================

    months = (0..5).map do |i|
      date = current_month_start - i.months

      {
        start: date.beginning_of_month,
        end: date.end_of_month,
        days: date.end_of_month.day
      }
    end.reverse

    six_month_start = months.first[:start]

    # ==================================================
    # MONTHLY SALES
    # ==================================================

    monthly_sales = Hash.new do |hash, key|
      hash[key] = Hash.new(0)
    end

    Jnewsale
      .where(
        created_at:
          six_month_start.beginning_of_day..today.end_of_day
      )
      .where.not(branch: nil)
      .where.not(bale_name: nil)
      .find_each do |sale|

        branch = normalize(sale.branch)
        bale_name = normalize(sale.bale_name)

        next if branch.blank?
        next if bale_name.blank?

        month =
          sale.created_at
              .to_date
              .beginning_of_month

        monthly_sales[
          [branch, bale_name]
        ][month] += sale.qty.to_i
      end

    # ==================================================
    # CURRENT STOCK
    # ==================================================

    stock = Hash.new(0)

    Jstock
      .where("qty > 0")
      .where.not(branch: nil)
      .where.not(bale_name: nil)
      .find_each do |record|

        branch = normalize(record.branch)
        bale_name = normalize(record.bale_name)

        next if branch.blank?
        next if bale_name.blank?

        stock[
          [branch, bale_name]
        ] += record.qty.to_i
      end

    # ==================================================
    # ALL BRANCH / BALE COMBINATIONS
    # ==================================================

    keys = (
      monthly_sales.keys +
      stock.keys
    ).uniq

    current_day = today.day
    days_in_current_month = today.end_of_month.day

    results = []

    keys.each do |branch, bale_name|

      next if branch.blank?
      next if bale_name.blank?

      # Do not create a sales prediction for Warehouse/HH
      # because they are supply locations.
      next if CENTRAL_STOCK_BRANCHES.include?(branch)

      # ==================================================
      # MONTHLY HISTORY
      # ==================================================

      monthly = months.map do |month|

        qty =
          monthly_sales[
            [branch, bale_name]
          ][month[:start]].to_i

        {
          month: month[:start].strftime("%b %Y"),
          qty: qty
        }

      end

      quantities =
        monthly.map { |month| month[:qty].to_i }

      # ==================================================
      # WEIGHTED 6-MONTH AVERAGE
      #
      # Older → newer
      #
      # 1, 1, 1, 2, 2, 3
      # ==================================================

      weights = [1, 1, 1, 2, 2, 3]

      weighted_total =
        quantities.zip(weights).sum do |qty, weight|

          qty.to_f * weight

        end

      weight_total = weights.sum

      weighted_average =
        if weight_total.zero?

          0

        else

          weighted_total / weight_total

        end

      # ==================================================
      # CURRENT MONTH
      # ==================================================

      current_month_sales =
        monthly_sales[
          [branch, bale_name]
        ][current_month_start].to_i

      # ==================================================
      # CURRENT MONTH SALES PACE
      # ==================================================

      current_month_daily_rate =
        if current_day > 0

          current_month_sales.to_f / current_day

        else

          0

        end

      projected_current_month =
        (
          current_month_daily_rate *
          days_in_current_month
        ).round

      # ==================================================
      # HISTORICAL TREND
      # ==================================================

      previous_quantities =
        quantities[0...-1]

      previous_average =
        if previous_quantities.any?

          previous_quantities.sum.to_f /
            previous_quantities.length

        else

          0

        end

      trend =
        if previous_average.zero? && weighted_average > 0

          "up"

        elsif weighted_average >
              previous_average * 1.15

          "up"

        elsif weighted_average <
              previous_average * 0.85

          "down"

        else

          "stable"

        end

      # ==================================================
      # FINAL FORECAST
      #
      # Historical demand = 70%
      # Current month pace = 30%
      # ==================================================

      forecast =
        if current_month_sales > 0

          (
            weighted_average * 0.70 +
            projected_current_month * 0.30
          ).round

        else

          weighted_average.round

        end

      forecast =
        [forecast, 0].max

      # ==================================================
      # CURRENT BRANCH STOCK
      # ==================================================

      branch_stock =
        stock[
          [branch, bale_name]
        ].to_i

      # ==================================================
      # CENTRAL STOCK
      #
      # HH + Warehouse
      # ==================================================

      central_stock =
        CENTRAL_STOCK_BRANCHES.sum do |central_branch|

          stock[
            [central_branch, bale_name]
          ].to_i

        end

      # ==================================================
      # TOTAL AVAILABLE
      # ==================================================

      total_available =
        branch_stock + central_stock

      # ==================================================
      # BRANCH SHORTAGE
      # ==================================================

      branch_requirement =
        [forecast - branch_stock, 0].max

      # ==================================================
      # TRANSFER FROM CENTRAL STOCK
      # ==================================================

      transferable_stock =
        [
          branch_requirement,
          central_stock
        ].min

      # ==================================================
      # ACTUAL PURCHASE REQUIREMENT
      # ==================================================

      purchase_requirement =
        [
          branch_requirement - transferable_stock,
          0
        ].max

      # ==================================================
      # STOCK STATUS
      # ==================================================

      status =
        if forecast <= 0

          "no_demand"

        elsif branch_stock >= forecast

          "enough"

        elsif branch_stock >= (forecast * 0.5)

          "low"

        else

          "stock"

        end

      # ==================================================
      # SUPPLY STATUS
      # ==================================================

      supply_status =
        if branch_requirement <= 0

          "available"

        elsif transferable_stock >= branch_requirement

          "transfer"

        elsif transferable_stock > 0

          "transfer_and_buy"

        else

          "buy"

        end

      # ==================================================
      # RESULT
      # ==================================================

      results << {

        branch: branch,

        bale_name: bale_name,

        monthly_sales: monthly,

        six_month_total:
          quantities.sum,

        weighted_average:
          weighted_average.round(1),

        current_month_sales:
          current_month_sales,

        current_month_daily_rate:
          current_month_daily_rate.round(2),

        projected_current_month:
          projected_current_month,

        forecast:
          forecast,

        current_stock:
          branch_stock,

        central_stock:
          central_stock,

        total_available:
          total_available,

        recommended_stock:
          branch_requirement,

        transfer_quantity:
          transferable_stock,

        purchase_quantity:
          purchase_requirement,

        status:
          status,

        supply_status:
          supply_status,

        trend:
          trend
      }

    end

    # ==================================================
    # SORT
    #
    # Biggest purchase requirement first
    # ==================================================

    results.sort_by do |item|

      [
        item[:purchase_quantity].to_i > 0 ? 0 : 1,
        -item[:purchase_quantity].to_i,
        -item[:transfer_quantity].to_i,
        -item[:recommended_stock].to_i,
        item[:branch].to_s,
        item[:bale_name].to_s
      ]

    end
  end

  def normalize(value)
    value.to_s.strip.squeeze(" ")
  end
end