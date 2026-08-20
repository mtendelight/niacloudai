class JmcustomerpaymentsController < ApplicationController
  require "csv"

  def index
    per_page = (params[:per_page] || 20).to_i
    query = params[:q]




   payments = Jmpayment.order(date: :desc)

@payments = payments
              .page(params[:page])
              .per(per_page)

    # 🔍 SEARCH FILTER
    if query.present?
      payments = payments.where(
        "jmpayments.mpesa_code ILIKE :q
         OR jmpayments.name ILIKE :q
         OR jmpayments.mpesa_number ILIKE :q
         OR jmpayments.transaction_ref ILIKE :q",
        q: "%#{query}%"
      )
    end

    # 🏆 TOP CUSTOMERS (SAFE GROUP QUERY)
    @top_customers = Jmcustomer
      .joins(:jmpayments)
      .select("
        jmcustomers.id,
        jmcustomers.name,
        jmcustomers.phone,
        SUM(jmpayments.amount) AS total_paid,
        COUNT(jmpayments.id) AS total_payments
      ")
      .group("jmcustomers.id, jmcustomers.name, jmcustomers.phone")
      .order("total_paid DESC")
      .limit(5)

      @top_customers_by_transactions = Jmcustomer
  .joins(:jmpayments)
  .select("
    jmcustomers.id,
    jmcustomers.name,
    jmcustomers.phone,
    SUM(jmpayments.amount) AS total_paid,
    COUNT(jmpayments.id) AS total_payments
  ")
  .group("jmcustomers.id, jmcustomers.name, jmcustomers.phone")
  .order("total_payments DESC")
  .limit(20)

    @top_customerss = Jmcustomer
      .joins(:jmpayments)
      .select("
        jmcustomers.id,
        jmcustomers.name,
        jmcustomers.phone,
        SUM(jmpayments.amount) AS total_paid,
        COUNT(jmpayments.id) AS total_payments
      ")
      .group("jmcustomers.id, jmcustomers.name, jmcustomers.phone")
      .order("total_paid DESC")
      .limit(25)


      @high_value_customers = Jmcustomer
  .joins(:jmpayments)
  .select("
    jmcustomers.id,
    jmcustomers.name,
    jmcustomers.phone,
    SUM(jmpayments.amount) AS total_paid,
    COUNT(jmpayments.id) AS total_payments
  ")
  .group("jmcustomers.id, jmcustomers.name, jmcustomers.phone")
  .having("SUM(jmpayments.amount) >= ?", 100_000)
  .order("total_paid DESC")

    respond_to do |format|
      # 📄 HTML VIEW
      format.html do


        m1_total = payments.where(
  date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month
).sum(:amount).to_f

m2_total = payments.where(
  date: 2.months.ago.beginning_of_month..2.months.ago.end_of_month
).sum(:amount).to_f

m3_total = payments.where(
  date: 3.months.ago.beginning_of_month..3.months.ago.end_of_month
).sum(:amount).to_f

avg_3_months = (m1_total + m2_total + m3_total) / 3.0

@projected_current_month = avg_3_months + 1_000_000

@projection_vs_last_month =
  if m1_total.positive?
    ((@projected_current_month - m1_total) / m1_total * 100).round
  else
    0
  end




  @avg_3_months = ((m1_total + m2_total + m3_total) / 3.0)

@projected_current_month = @avg_3_months + 1_000_000


current_year_start = Date.current.beginning_of_year
current_year_end   = Date.current.end_of_year

prev_year_start = 1.year.ago.beginning_of_year
prev_year_end   = 1.year.ago.end_of_year

prev2_year_start = 2.years.ago.beginning_of_year
prev2_year_end   = 2.years.ago.end_of_year

@current_year_total = payments.where(
  date: current_year_start..current_year_end
).sum(:amount)

@prev_year_total = payments.where(
  date: prev_year_start..prev_year_end
).sum(:amount)

@prev2_year_total = payments.where(
  date: prev2_year_start..prev2_year_end
).sum(:amount)

@year_growth_1 =
  @prev_year_total > 0 ?
  ((@current_year_total - @prev_year_total) / @prev_year_total.to_f * 100).round : 0

@year_growth_2 =
  @prev2_year_total > 0 ?
  ((@prev_year_total - @prev2_year_total) / @prev2_year_total.to_f * 100).round : 0



        today = Date.current

# =========================
# LAST 3 MONTHS TOTALS
# =========================
m1_start = 1.month.ago.beginning_of_month
m1_end   = 1.month.ago.end_of_month

m2_start = 2.months.ago.beginning_of_month
m2_end   = 2.months.ago.end_of_month

m3_start = 3.months.ago.beginning_of_month
m3_end   = 3.months.ago.end_of_month

m1_total = payments.where(date: m1_start..m1_end).sum(:amount).to_f
m2_total = payments.where(date: m2_start..m2_end).sum(:amount).to_f
m3_total = payments.where(date: m3_start..m3_end).sum(:amount).to_f

# =========================
# AVERAGE OF LAST 3 MONTHS
# =========================
avg_3_months = (m1_total + m2_total + m3_total) / 3.0

# =========================
# PROJECTION (NEXT MONTH BASED ON TREND)


# =========================
@projected_current_month = (avg_3_months * 1.0).round

m1 = payments.where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:amount).to_f
m2 = payments.where(date: 2.months.ago.beginning_of_month..2.months.ago.end_of_month).sum(:amount).to_f
m3 = payments.where(date: 3.months.ago.beginning_of_month..3.months.ago.end_of_month).sum(:amount).to_f

avg_3_months = (m1 + m2 + m3) / 3.0







trend_factor =
  if m2_total > 0 && m3_total > 0
    ((m1_total - m2_total) + (m2_total - m3_total)) / 2.0
  else
    0
  end

  @projected_current_month = (avg_3_months + trend_factor).round

@projection_vs_last_month =
  if @prev_month_total.to_f > 0
    (
      (@projected_current_month - @prev_month_total) /
      @prev_month_total.to_f * 100
    ).round
  else
    0
  end




        today = Date.current

current_start = today.beginning_of_month
days_passed   = today.day
days_in_month = today.end_of_month.day

@current_month_total = payments.where(date: current_start..today).sum(:amount)

current = @projected_current_month.to_f
prev    = @prev_month_total.to_f

@projection_vs_last_month =
  prev.positive? ? ((current - prev) / prev * 100).round : 0


        today = Date.current

current_start = today.beginning_of_month
current_end   = today.end_of_month

prev1_start = 1.month.ago.beginning_of_month
prev1_end   = 1.month.ago.end_of_month

prev2_start = 2.months.ago.beginning_of_month
prev2_end   = 2.months.ago.end_of_month

# 📊 MONTHLY TOTALS
@current_month_total = payments.where(date: current_start..current_end).sum(:amount)
@prev_month_total    = payments.where(date: prev1_start..prev1_end).sum(:amount)
@prev2_month_total   = payments.where(date: prev2_start..prev2_end).sum(:amount)

@month_growth_1 =
  @prev_month_total > 0 ?
  ((@current_month_total - @prev_month_total) / @prev_month_total.to_f * 100).round : 0

@month_growth_2 =
  @prev2_month_total > 0 ?
  ((@prev_month_total - @prev2_month_total) / @prev2_month_total.to_f * 100).round : 0

 # =========================
# 📅 DATES
# =========================
today = Date.current

current_start = today.beginning_of_month

prev1_start = today.last_month.beginning_of_month
prev1_end   = today.last_month.end_of_month

prev2_start = today.prev_month(2).beginning_of_month
prev2_end   = today.prev_month(2).end_of_month

@three_days_ago_total = payments.where(date: Date.current - 3).sum(:amount)


today = Date.current
start_date = today - 90.days

same_days = Jmpayment
  .where(date: start_date..today)
  .where("EXTRACT(DOW FROM date) = ?", today.wday)
  .group(:date)
  .sum(:amount)
  .values

@forecast_3m = if same_days.any?
  (same_days.sum / same_days.size.to_f).round
else
  0
end

# =========================
# 📊 RAW DATA
# =========================
current_data = Jmpayment
  .where(date: current_start..today)
  .group(:date)
  .sum(:amount)

prev1_data = Jmpayment
  .where(date: prev1_start..prev1_end)
  .group(:date)
  .sum(:amount)

prev2_data = Jmpayment
  .where(date: prev2_start..prev2_end)
  .group(:date)
  .sum(:amount)

# =========================
# 📊 NORMALIZE (FOR CHART)
# =========================
days = (1..today.end_of_month.day).to_a
@days = days

@current_daily = days.map do |d|
  current_data[Date.new(today.year, today.month, d)] || 0
end

@prev1_daily = days.map do |d|
  date = prev1_start.change(day: [d, prev1_end.day].min)
  prev1_data[date] || 0
end

@prev2_daily = days.map do |d|
  date = prev2_start.change(day: [d, prev2_end.day].min)
  prev2_data[date] || 0
end

# =========================
# 📈 TOTALS
# =========================
@curr_total  = @current_daily.sum
@prev1_total = @prev1_daily.sum
@prev2_total = @prev2_daily.sum

# =========================
# 📊 GROWTH %
# =========================
@growth_1 = @prev1_total > 0 ? ((@curr_total - @prev1_total).to_f / @prev1_total * 100).round : 0
@growth_2 = @prev2_total > 0 ? ((@prev1_total - @prev2_total).to_f / @prev2_total * 100).round : 0

# =========================
# 🔮 FORECAST
# =========================
days_passed   = today.day
days_in_month = today.end_of_month.day

avg_daily = days_passed > 0 ? @curr_total / days_passed.to_f : 0
@forecast = (avg_daily * days_in_month).round

# =========================
# 📊 CUMULATIVE (TREND)
# =========================
@current_cumulative = @current_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }
@prev1_cumulative   = @prev1_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }
@prev2_cumulative   = @prev2_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }


# =========================
# 📅 REVENUE BY WEEKDAY
# =========================

current_week_start = Date.current.beginning_of_week(:sunday)
last_week_start    = current_week_start - 1.week
last_week_end      = current_week_start - 1.day

current_week = Jmpayment
  .where(date: current_week_start..Date.current)
  .group("EXTRACT(DOW FROM date)::integer")
  .sum(:amount)

last_week = Jmpayment
  .where(date: last_week_start..last_week_end)
  .group("EXTRACT(DOW FROM date)::integer")
  .sum(:amount)

@weekday_labels = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday"
]

@current_week_totals = (0..6).map { |dow| current_week[dow] || 0 }
@last_week_totals    = (0..6).map { |dow| last_week[dow] || 0 }

@current_total = @current_week_totals.sum
@last_total    = @last_week_totals.sum

@week_growth = if @last_total.positive?
                 (((@current_total - @last_total) / @last_total.to_f) * 100).round(1)
               else
                 0
               end



               
# =========================
# WEEKDAY COMPARISON
# THIS WEEK vs LAST WEEK
# =========================

@weekday_labels = %w[Sun Mon Tue Wed Thu Fri Sat]

this_week_start = Date.current.beginning_of_week(:sunday)
last_week_start = this_week_start - 7.days
last_week_end   = this_week_start - 1.day

this_week_data = Jmpayment
  .where(date: this_week_start..Date.current)
  .group(:date)
  .sum(:amount)

last_week_data = Jmpayment
  .where(date: last_week_start..last_week_end)
  .group(:date)
  .sum(:amount)

@this_week = []
@last_week = []

(0..6).each do |i|
  current_date = this_week_start + i.days
  previous_date = last_week_start + i.days

  @this_week << (this_week_data[current_date] || 0)
  @last_week << (last_week_data[previous_date] || 0)
end

@best_day_index = @this_week.index(@this_week.max)
@best_day = @weekday_labels[@best_day_index]

@worst_day_index = @this_week.index(@this_week.reject(&:zero?).min || 0)
@worst_day = @weekday_labels[@worst_day_index]
# =========================
# 🔥 BEST / WORST DAY
# =========================
# BEST DAY
best_value = @current_daily.max || 0
best_index = @current_daily.index(best_value)

@best_day = best_value
@best_day_date =
  best_index ? Date.current.beginning_of_month + best_index.days : nil

# WORST DAY (ignore zeros)
filtered = @current_daily.reject(&:zero?)

worst_value = filtered.min || 0
worst_index = @current_daily.index(worst_value)

@worst_day = worst_value
@worst_day_date =
  worst_index ? Date.current.beginning_of_month + worst_index.days : nil

days_range = (0...(today.day)).to_a

current_data = Jmpayment
  .where(date: current_start..today)
  .group(:date)
  .sum(:amount)

prev1_data = Jmpayment
  .where(date: prev1_start..(prev1_start + today.day - 1))
  .group(:date)
  .sum(:amount)

prev2_data = Jmpayment
  .where(date: prev2_start..(prev2_start + today.day - 1))
  .group(:date)
  .sum(:amount)

@days = []
@current_daily = []
@prev1_daily = []
@prev2_daily = []

days_range.each do |i|
  d1 = current_start + i
  d2 = prev1_start + i
  d3 = prev2_start + i

  @days << d1.strftime("%d %b")

  @current_daily << (current_data[d1] || 0)
  @prev1_daily  << (prev1_data[d2] || 0)
  @prev2_daily  << (prev2_data[d3] || 0)
end

@forecast = (avg_daily * days_in_month).round

@current_cumulative = @current_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }
@prev1_cumulative   = @prev1_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }
@prev2_cumulative   = @prev2_daily.each_with_object([]) { |v, arr| arr << (arr.last || 0) + v }
        @today = payments.where(date: Date.current)
                         .order(updated_at: :desc)
                         .page(params[:page]).per(per_page)

        @yesterday = payments.where(date: Date.current - 1)
                              .order(updated_at: :desc)
                              .page(params[:page]).per(per_page)

        @day_before = payments.where(date: Date.current - 2)
                              .order(updated_at: :desc)
                              .page(params[:page]).per(per_page)

        @older = payments.where("date < ?", Date.current - 2)
                         .order(updated_at: :desc)
                         .page(params[:page]).per(per_page)

        @today_total = payments.where(date: Date.current).sum(:amount)
@yesterday_total = payments.where(date: Date.current - 1).sum(:amount)
@day_before_total = payments.where(date: Date.current - 2).sum(:amount)
@older_total = payments.where("date < ?", Date.current - 2).sum(:amount)
      end

format.csv do
  case params[:type]

  when "high_value_customers"
    data = Jmcustomer
      .joins(:jmpayments)
      .select("
        jmcustomers.id,
        jmcustomers.name,
        jmcustomers.phone,
        SUM(jmpayments.amount) AS total_paid,
        COUNT(jmpayments.id) AS total_payments
      ")
      .group("jmcustomers.id, jmcustomers.name, jmcustomers.phone")
      .having("SUM(jmpayments.amount) >= ?", 100_000)
      .order("total_paid DESC")

    return send_data generate_high_value_csv(data),
      filename: "high-value-customers-#{Date.today}.csv"

 when "current_month"
  return send_data generate_csv(
    payments.where(
      date: Date.current.beginning_of_month..Date.current.end_of_month
    )
  ),
  filename: "payments-current-month-#{Date.today}.csv"

when "last_month"
  return send_data generate_csv(
    payments.where(
      date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month
    )
  ),
  filename: "payments-last-month-#{Date.today}.csv"

when "prev2_month"
  return send_data generate_csv(
    payments.where(
      date: 2.months.ago.beginning_of_month..2.months.ago.end_of_month
    )
  ),
  filename: "payments-two-months-ago-#{Date.today}.csv"

  when "today"
    return send_data generate_csv(
      payments.where(date: Date.current)
    ),
    filename: "payments-today-#{Date.today}.csv"

  when "yesterday"
    return send_data generate_csv(
      payments.where(date: Date.current - 1.day)
    ),
    filename: "payments-yesterday-#{Date.today}.csv"

  when "day_before"
    return send_data generate_csv(
      payments.where(date: Date.current - 2.days)
    ),
    filename: "payments-day-before-#{Date.today}.csv"

  when "older"
    return send_data generate_csv(
      payments.where("date < ?", Date.current - 2.days)
    ),
    filename: "payments-older-#{Date.today}.csv"

  else
    return send_data generate_csv(payments),
      filename: "payments-all-#{Date.today}.csv"
  end
end
end end
  private


  def generate_high_value_csv(customers)
  CSV.generate(headers: true) do |csv|
    csv << [
      "Customer ID",
      "Name",
      "Phone",
      "Total Paid",
      "Total Transactions"
    ]

    customers.find_each do |c|
      csv << [
        c.id,
        c.name,
        c.phone,
        c.total_paid.to_i,
        c.total_payments
      ]
    end
  end
end

  # 📊 CSV GENERATOR
  def generate_csv(payments)
    CSV.generate(headers: true) do |csv|
      csv << [
        "ID",
        "Customer",
        "Phone",
        "Mpesa Code",
        "Mpesa Number",
        "Transaction Ref",
        "Amount",
        "Date"
      ]

      payments.find_each do |p|
        csv << [
          p.id,
          p.jmcustomer&.name,
          p.jmcustomer&.phone,
          p.mpesa_code,
          p.mpesa_number,
          p.transaction_ref,
          p.amount,
          p.date
        ]
      end
    end
  end
end