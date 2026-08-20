
class BalesPredictionsController < ApplicationController

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

  # ==========================================
  # INDEX
  # ==========================================

  def index

      #BalesPredictionJob.perform_later

    # ------------------------------------------
    # LOAD PREDICTIONS
    # ------------------------------------------

    @predictions =
      Rails.cache.read(
        BalesPredictionJob::CACHE_KEY
      ) || []

    @predictions = [] unless @predictions.is_a?(Array)

    # ------------------------------------------
    # SELECTED BRANCH
    # ------------------------------------------

    @selected_branch =
      params[:branch].presence

    if @selected_branch.present?

      @predictions =
        @predictions.select do |prediction|

          prediction[:branch].to_s ==
            @selected_branch.to_s

        end

    end

    # ------------------------------------------
    # STOCK RECOMMENDATIONS
    # ------------------------------------------

    @stock_recommendations =
      @predictions
        .select do |prediction|
          prediction[:recommended_stock].to_i > 0
        end
        .sort_by do |prediction|
          -prediction[:recommended_stock].to_i
        end

    # ------------------------------------------
    # BASIC SUMMARY
    # ------------------------------------------

    @total_predictions =
      @predictions.size

    @need_stock =
      @predictions.select do |prediction|
        prediction[:status].to_s == "stock"
      end

    @low_stock =
      @predictions.select do |prediction|
        prediction[:status].to_s == "low"
      end

    @enough_stock =
      @predictions.select do |prediction|
        prediction[:status].to_s == "enough"
      end

    @no_demand =
      @predictions.select do |prediction|
        prediction[:status].to_s == "no_demand"
      end

    # ------------------------------------------
    # TOTALS
    # ------------------------------------------

    @total_bales_to_stock =
      @need_stock.sum do |prediction|
        prediction[:recommended_stock].to_i
      end

    @total_forecast =
      @predictions.sum do |prediction|
        prediction[:forecast].to_i
      end

    @total_current_stock =
      @predictions.sum do |prediction|
        prediction[:current_stock].to_i
      end

    # ==========================================
    # CURRENT DAILY SALES
    # ==========================================
    #
    # We calculate current sales pace using
    # the current month's sales divided by
    # days elapsed in the month.
    #
    # This gives us a realistic "days of stock"
    # calculation.
    #

    days_elapsed =
      Date.current.day

    days_elapsed =
      1 if days_elapsed <= 0

    @predictions.each do |prediction|

      current_month_sales =
        prediction[:current_month_sales].to_i

      current_daily_sales =
        current_month_sales.to_f /
        days_elapsed

      prediction[:current_daily_sales] =
        current_daily_sales.round(2)

      # ----------------------------------------
      # DAYS OF STOCK
      # ----------------------------------------

      current_stock =
        prediction[:current_stock].to_i

      if current_daily_sales > 0

        prediction[:days_of_stock] =
          (current_stock.to_f /
            current_daily_sales).round(1)

      else

        prediction[:days_of_stock] = nil

      end

    end

    # ==========================================
    # CRITICAL STOCK
    # ==========================================
    #
    # Bales expected to run out within 7 days.
    #

    @critical_stock =
      @predictions
        .select do |prediction|

          days =
            prediction[:days_of_stock]

          days.present? &&
            days <= 7 &&
            prediction[:current_stock].to_i > 0

        end
        .sort_by do |prediction|

          prediction[:days_of_stock].to_f

        end

    @critical_count =
      @critical_stock.size

    # ==========================================
    # FAST MOVING
    # ==========================================
    #
    # Highest six-month sales volume.
    #
    # We use the top 25% of sales volume as
    # fast-moving stock.
    #

    sales_totals =
      @predictions.map do |prediction|
        prediction[:six_month_total].to_i
      end

    sorted_sales =
      sales_totals.sort

    fast_threshold =
      if sorted_sales.any?

        index =
          (sorted_sales.length * 0.75).floor

        sorted_sales[index] ||
          sorted_sales.last

      else

        0

      end

    @fast_moving =
      @predictions
        .select do |prediction|

          prediction[:six_month_total].to_i >=
            fast_threshold &&
            prediction[:six_month_total].to_i > 0

        end
        .sort_by do |prediction|

          -prediction[:six_month_total].to_i

        end

    @fast_moving_count =
      @fast_moving.size

    # ==========================================
    # SLOW MOVING / OVERSTOCK
    # ==========================================
    #
    # Current stock significantly exceeds
    # predicted demand.
    #

    @slow_moving =
      @predictions
        .select do |prediction|

          forecast =
            prediction[:forecast].to_i

          current_stock =
            prediction[:current_stock].to_i

          six_month_total =
            prediction[:six_month_total].to_i

          # Ignore items with no stock
          # and no historical sales.

          next false if current_stock <= 0
          next false if forecast <= 0

          # Overstock = stock is at least
          # 1.5x the forecast.

          current_stock >=
            (forecast * 1.5) &&
            six_month_total > 0

        end
        .sort_by do |prediction|

          -prediction[:current_stock].to_i

        end

    @slow_moving_count =
      @slow_moving.size

    # ==========================================
    # BRANCHES
    # ==========================================

    @branches =
      @predictions
        .map { |prediction| prediction[:branch] }
        .compact
        .uniq
        .sort

    # ==========================================
    # BRANCH SUMMARY
    # ==========================================

    @branch_summary =
      @predictions
        .group_by do |prediction|
          prediction[:branch]
        end
        .map do |branch, predictions|

          {
            branch: branch,

            forecast:
              predictions.sum do |prediction|
                prediction[:forecast].to_i
              end,

            current_stock:
              predictions.sum do |prediction|
                prediction[:current_stock].to_i
              end,

            recommended_stock:
              predictions.sum do |prediction|
                prediction[:recommended_stock].to_i
              end,

            need_stock:
              predictions.count do |prediction|
                prediction[:status].to_s == "stock"
              end,

            low_stock:
              predictions.count do |prediction|
                prediction[:status].to_s == "low"
              end,

            enough_stock:
              predictions.count do |prediction|
                prediction[:status].to_s == "enough"
              end,

            no_demand:
              predictions.count do |prediction|
                prediction[:status].to_s == "no_demand"
              end
          }

        end
        .sort_by do |branch|
          -branch[:recommended_stock].to_i
        end

    # ==========================================
    # BRANCH TRANSFER OPPORTUNITIES
    # ==========================================
    #
    # Find a branch with surplus and another
    # branch that needs the same bale.
    #

    @transfers = []

    grouped_bales =
      @predictions.group_by do |prediction|
        prediction[:bale_name]
      end

    grouped_bales.each do |bale_name, predictions|

      next if bale_name.blank?

      surplus_branches =
        predictions.select do |prediction|

          forecast =
            prediction[:forecast].to_i

          current_stock =
            prediction[:current_stock].to_i

          forecast > 0 &&
            current_stock >
              (forecast * 1.5)

        end

      shortage_branches =
        predictions.select do |prediction|

          prediction[:recommended_stock].to_i > 0

        end

      surplus_branches.each do |from|

        shortage_branches.each do |to|

          next if from[:branch] == to[:branch]

          surplus_quantity =
            from[:current_stock].to_i -
            from[:forecast].to_i

          shortage_quantity =
            to[:recommended_stock].to_i

          quantity =
            [surplus_quantity, shortage_quantity].min

          next if quantity <= 0

          @transfers << {

            from_branch:
              from[:branch],

            to_branch:
              to[:branch],

            bale_name:
              bale_name,

            quantity:
              quantity

          }

        end

      end

    end

    # Highest transfer quantities first

    @transfers =
      @transfers
        .sort_by do |transfer|

          -transfer[:quantity].to_i

        end

    @transfer_count =
      @transfers.size

    # ------------------------------------------
    # LAST UPDATED
    # ------------------------------------------

    @prediction_updated_at =
      Rails.cache.read(
        "#{BalesPredictionJob::CACHE_KEY}:updated_at"
      )

    # ------------------------------------------
    # FALLBACK UPDATED TIME
    # ------------------------------------------

    if @prediction_updated_at.blank?

      @prediction_updated_at =
        Jnewsale.maximum(:created_at)

    end

  end


  # ==========================================
  # REFRESH
  # ==========================================

  def refresh

    BalesPredictionJob.perform_later

    redirect_to bales_predictions_path,
                notice: "Bales prediction is being recalculated."

  end


# ==========================================
# EXCEL EXPORT
# ==========================================

def export

  predictions =
    Rails.cache.read(
      BalesPredictionJob::CACHE_KEY
    ) || []

  predictions = [] unless predictions.is_a?(Array)

  # ==========================================
  # HH STOCK
  # Used ONLY to reduce Nairobi restock
  # ==========================================

  hh_stock =
    predictions
      .select do |prediction|
        prediction[:branch].to_s.strip.casecmp("HH").zero?
      end
      .group_by do |prediction|
        prediction[:bale_name].to_s.strip.downcase
      end
      .transform_values do |items|
        items.sum do |prediction|
          prediction[:current_stock].to_i
        end
      end

  # ==========================================
  # CALCULATE FINAL RESTOCK
  # ==========================================

  predictions_with_restock =
    predictions.map do |prediction|

      branch =
        prediction[:branch].to_s.strip

      bale_name =
        prediction[:bale_name].to_s.strip

      original_restock =
        prediction[:recommended_stock].to_i

      # ----------------------------------------
      # ONLY NAIROBI GETS HH DEDUCTION
      # ----------------------------------------

      if branch.casecmp("Nairobi").zero?

        hh_qty =
          hh_stock[bale_name.downcase].to_i

        final_restock =
          [original_restock - hh_qty, 0].max

      else

        final_restock =
          original_restock

      end

      prediction.merge(
        export_restock: final_restock
      )
    end

  # ==========================================
  # ACTIVE BRANCHES
  # ==========================================

  active_branches =
    predictions_with_restock
      .map { |prediction| prediction[:branch].to_s.strip }
      .reject(&:blank?)
      .uniq
      .sort

  respond_to do |format|

    format.xlsx do

      package = Axlsx::Package.new
      workbook = package.workbook

      # ==========================================
      # TAB 1 — SUMMARY
      # ==========================================

      workbook.add_worksheet(name: "Summary") do |sheet|

        sheet.add_row [
          "BALES RESTOCK SUMMARY"
        ]

        sheet.add_row [
          "Generated",
          Time.current.strftime("%d/%m/%Y %H:%M")
        ]

        sheet.add_row []

        sheet.add_row [
          "Branch",
          "Current Stock",
          "Forecast",
          "To Restock",
          "Bales Needing Stock"
        ]

        active_branches.each do |branch|

          branch_predictions =
            predictions_with_restock.select do |prediction|
              prediction[:branch].to_s.strip == branch
            end

          current_stock =
            branch_predictions.sum do |prediction|
              prediction[:current_stock].to_i
            end

          forecast =
            branch_predictions.sum do |prediction|
              prediction[:forecast].to_i
            end

          recommended =
            branch_predictions.sum do |prediction|
              prediction[:export_restock].to_i
            end

          need_stock =
            branch_predictions.count do |prediction|
              prediction[:export_restock].to_i > 0
            end

          sheet.add_row [
            branch,
            current_stock,
            forecast,
            recommended,
            need_stock
          ]

        end

        # ==========================================
        # GRAND TOTAL
        # ==========================================

        sheet.add_row []

        sheet.add_row [
          "TOTAL",
          predictions_with_restock.sum do |prediction|
            prediction[:current_stock].to_i
          end,
          predictions_with_restock.sum do |prediction|
            prediction[:forecast].to_i
          end,
          predictions_with_restock.sum do |prediction|
            prediction[:export_restock].to_i
          end,
          predictions_with_restock.count do |prediction|
            prediction[:export_restock].to_i > 0
          end
        ]

        sheet.column_widths 22, 18, 18, 18, 22

      end

      # ==========================================
      # BRANCH TABS
      # ONLY BALES TO RESTOCK
      # ==========================================

      active_branches.each do |branch|

        branch_predictions =
          predictions_with_restock
            .select do |prediction|

              prediction[:branch].to_s.strip == branch &&
                prediction[:export_restock].to_i > 0

            end
            .sort_by do |prediction|

              -prediction[:export_restock].to_i

            end

        # ------------------------------------------
        # SKIP BRANCH IF NOTHING NEEDS RESTOCKING
        # ------------------------------------------

        next if branch_predictions.empty?

        # ------------------------------------------
        # EXCEL SHEET NAME
        # ------------------------------------------

        sheet_name =
          branch.to_s
                .gsub(/[\[\]:*?\/\\]/, "")
                .first(31)

        workbook.add_worksheet(name: sheet_name) do |sheet|

          # ----------------------------------------
          # TITLE
          # ----------------------------------------

          sheet.add_row [
            "#{branch} - TO RESTOCK"
          ]

          sheet.add_row []

          # ----------------------------------------
          # HEADERS
          # ----------------------------------------

          sheet.add_row [
            "Bale Name",
            "Current Stock",
            "To Restock"
          ]

          # ----------------------------------------
          # BALES
          # ----------------------------------------

          branch_predictions.each do |prediction|

            sheet.add_row [
              prediction[:bale_name].to_s,
              prediction[:current_stock].to_i,
              prediction[:export_restock].to_i
            ]

          end

          # ----------------------------------------
          # TOTAL
          # ----------------------------------------

          sheet.add_row []

          sheet.add_row [
            "TOTAL",
            branch_predictions.sum do |prediction|
              prediction[:current_stock].to_i
            end,
            branch_predictions.sum do |prediction|
              prediction[:export_restock].to_i
            end
          ]

          # ----------------------------------------
          # COLUMN WIDTHS
          # ----------------------------------------

          sheet.column_widths 40, 18, 18

        end

      end

      # ==========================================
      # DOWNLOAD
      # ==========================================

      send_data(
        package.to_stream.read,
        filename: "bales_restock_#{Date.current}.xlsx",
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )

    end

  end

end


  # ==========================================
  # REBUILD NOW
  # ==========================================

  def rebuild_now

    BalesPredictionJob.perform_now

    redirect_to bales_predictions_path,
                notice: "Bales predictions updated successfully."

  rescue => e

    Rails.logger.error(
      "[BalesPredictionsController] #{e.class}: #{e.message}"
    )

    redirect_to bales_predictions_path,
                alert: "Prediction update failed: #{e.message}"

  end

end
