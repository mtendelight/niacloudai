class JbiController < ApplicationController
skip_before_action :authenticate_user!

  def index
    @fulfillment = {
      all: Jfulfillment.count,
      pending: Jfulfillment.where(status: "pending").count,
      dispatched: Jfulfillment.where(status: "dispatched").count,
      delivered: Jfulfillment.where(status: "delivered").count,
      cancelled: Jfulfillment.where(status: "refund_cancelled").count,
      care: Jfulfillment.where(
        feedback: "negative",
        issue_status: "pending"
      ).count,
      refunded: Jfulfillment.where(status: "refunded").count
    }


  # =====================================================
  # BASE DATA
  # =====================================================

  @today = Date.current

   leads = Janomaxlead.all
    calls = Janomaxleadcall.all


  # =====================================================
  # EXECUTIVE KPIs
  # =====================================================

  @total_calls          = calls.count
  @unique_leads         = Janomaxlead.count
@converted = Janomaxlead.converted_leads.count
@open_leads = Janomaxlead.open_leads.count

  @existing_customers   = Janomaxlead.where(customer_exists: true).count
  @new_leads            = Janomaxlead.where(customer_exists: false).count

  @answered_calls       = calls.where(status: "ANSWERED").count
  @abandoned_calls      = calls.where(status: "ABANDONED").count
  @busy_calls           = calls.where(status: "BUSY").count
  @failed_calls         = calls.where(status: "FAILED").count
  @voicemail_calls      = calls.where(status: "VOICEMAIL").count

  @no_answer_calls =
    calls.where("UPPER(status) LIKE ?", "%NO ANSWER%").count

  @conversion_rate =
    if @unique_leads.zero?
      0
    else
      ((@converted.to_f / @unique_leads) * 100).round(1)
    end

  @avg_calls_per_lead =
    if @unique_leads.zero?
      0
    else
      (@total_calls.to_f / @unique_leads).round(2)
    end

  @followed_up =
    Janomaxlead.where.not(last_called_at: nil).count

  @follow_up_rate =
    if @unique_leads.zero?
      0
    else
      ((@followed_up.to_f / @unique_leads) * 100).round(1)
    end

  @max_open_lead_calls =
    Janomaxlead.where(lead_status: "open")
               .maximum(:calls_count) || 0

  # =====================================================
  # TODAY SUMMARY
  # =====================================================

  @today_calls =
    Janomaxleadcall.where(created_at: @today.all_day).count

  @today_leads =
    Janomaxlead.where(created_at: @today.all_day).count
@today_converted =
  Janomaxlead.converted_lead_status
             .where(updated_at: @today.all_day)
             .count

@today_open =
  Janomaxlead.where(lead_status: "open").count

  # =====================================================
  # YESTERDAY
  # =====================================================

  yesterday = @today - 1.day

  @yesterday_calls =
    Janomaxleadcall.where(created_at: yesterday.all_day).count

  @yesterday_leads =
    Janomaxlead.where(created_at: yesterday.all_day).count

  @yesterday_converted =
  Janomaxlead.where(
    lead_status: "converted",
    updated_at: yesterday.all_day
  ).count

  # =====================================================
  # GROWTH
  # =====================================================

  @calls_growth =
    if @yesterday_calls.zero?
      0
    else
      (((@today_calls - @yesterday_calls).to_f /
        @yesterday_calls) * 100).round(1)
    end

  @lead_growth =
    if @yesterday_leads.zero?
      0
    else
      (((@today_leads - @yesterday_leads).to_f /
        @yesterday_leads) * 100).round(1)
    end

  @conversion_growth =
    if @yesterday_converted.zero?
      0
    else
      (((@today_converted - @yesterday_converted).to_f /
        @yesterday_converted) * 100).round(1)
    end

  # =====================================================
  # SALES FUNNEL
  # =====================================================

  @funnel = {
    calls: @total_calls,
    leads: @unique_leads,
    open: @open_leads,
    converted: @converted
  }

  # =====================================================
  # LAST 30 DAYS
  # =====================================================

  @daily_calls =
    Janomaxleadcall.group_by_day(:created_at, last: 30).count

  @daily_leads =
    Janomaxlead.group_by_day(:created_at, last: 30).count

@daily_conversions =
  Janomaxlead.where(lead_status: "converted")
             .group_by_day(:updated_at, last: 30)
             .count

  # =====================================================
  # CALL STATUS PIE
  # =====================================================

  @call_status = {
    Answered: @answered_calls,
    Busy: @busy_calls,
    "No Answer": @no_answer_calls,
    Abandoned: @abandoned_calls,
    Failed: @failed_calls,
    Voicemail: @voicemail_calls
  }

  # =====================================================
  # MONTHLY COMPARISON
  # =====================================================

  @monthly_calls =
    Janomaxleadcall.group_by_month(:created_at, last: 12).count



  # =====================================================
  # LATEST CONVERSIONS
  # =====================================================
    @monthly_conversions =
      Janomaxlead.where(lead_status: "converted")
                 .group_by_month(:updated_at, last: 12)
                 .count

@daily_leads =
  Janomaxlead
    .group_by_day(:created_at, last: 30)
    .count

@daily_conversions =
  Janomaxlead
    .where(lead_status: "converted")
    .group_by_day(:updated_at, last: 30)
    .count

@daily_calls =
  Janomaxleadcall
    .group_by_day(:created_at, last: 30)
    .count

@daily_leads =
  Janomaxlead
    .group_by_day(:created_at, last: 30)
    .count
# ============================================
# LAST 16 DAYS FOLLOW-UP COUNTS
# ============================================

@followup_days = (0..5).map do |i|

  date = Date.current - i

  count = Janomaxlead.find_by_sql(<<~SQL).count
    SELECT jl.id
    FROM janomaxleads jl

    LEFT JOIN LATERAL (
      SELECT called_at,
             status
      FROM janomaxleadcalls
      WHERE janomaxlead_id = jl.id
      ORDER BY called_at DESC, id DESC
      LIMIT 1
    ) inbound ON TRUE

    LEFT JOIN LATERAL (
      SELECT called_at,
             status
      FROM janomax_outbound_calls
      WHERE janomaxlead_id = jl.id
      ORDER BY called_at DESC, id DESC
      LIMIT 1
    ) outbound ON TRUE

    WHERE jl.lead_status = 'open'

      -- Activity happened this day
      AND GREATEST(
            COALESCE(inbound.called_at,'1900-01-01'),
            COALESCE(outbound.called_at,'1900-01-01'),
            COALESCE(jl.last_handled_at,'1900-01-01')
          )
          BETWEEN '#{date.beginning_of_day}'
              AND '#{date.end_of_day}'

      -- Latest inbound wasn't answered
      AND (
            inbound.status IS NULL
            OR UPPER(TRIM(inbound.status)) <> 'ANSWERED'
          )

      -- Customer still waiting
      AND (
            (
              outbound.called_at IS NULL
              OR inbound.called_at > outbound.called_at
            )
            AND
            (
              jl.last_handled_at IS NULL
              OR jl.last_handled_at < inbound.called_at
            )
          )
  SQL

  {
    date: date,
    count: count
  }

end

# ============================================
# FILTER BY DATE
# ============================================

if params[:followup_date].present?

  date = Date.parse(params[:followup_date]) rescue nil

  if date

    @janomaxleads = Janomaxlead.find_by_sql(<<~SQL)

      SELECT jl.*

      FROM janomaxleads jl

      LEFT JOIN LATERAL (
        SELECT called_at,
               status
        FROM janomaxleadcalls
        WHERE janomaxlead_id = jl.id
        ORDER BY called_at DESC, id DESC
        LIMIT 1
      ) inbound ON TRUE

      LEFT JOIN LATERAL (
        SELECT called_at,
               status
        FROM janomax_outbound_calls
        WHERE janomaxlead_id = jl.id
        ORDER BY called_at DESC, id DESC
        LIMIT 1
      ) outbound ON TRUE

      WHERE jl.lead_status = 'open'

        AND GREATEST(
              COALESCE(inbound.called_at,'1900-01-01'),
              COALESCE(outbound.called_at,'1900-01-01'),
              COALESCE(jl.last_handled_at,'1900-01-01')
            )
            BETWEEN '#{date.beginning_of_day}'
                AND '#{date.end_of_day}'

        AND (
              inbound.status IS NULL
              OR UPPER(TRIM(inbound.status)) <> 'ANSWERED'
            )

        AND (
              (
                outbound.called_at IS NULL
                OR inbound.called_at > outbound.called_at
              )
              AND
              (
                jl.last_handled_at IS NULL
                OR jl.last_handled_at < inbound.called_at
              )
            )

      ORDER BY GREATEST(
                COALESCE(inbound.called_at,'1900-01-01'),
                COALESCE(outbound.called_at,'1900-01-01'),
                COALESCE(jl.last_handled_at,'1900-01-01')
              ) DESC

    SQL

    @janomaxleads = Kaminari.paginate_array(@janomaxleads)
                            .page(params[:page])
                            .per(per_page)

  end

end


# ==================================================
    # BASE
    # ==================================================

    @leads = Jmlead.all


    # ==================================================
    # DATE FILTER
    # ==================================================

    @period = params[:period].presence || "all"

    case @period

    when "today"

      @leads = @leads.where(
        created_at: Time.zone.today.all_day
      )

    when "yesterday"

      @leads = @leads.where(
        created_at: 1.day.ago.all_day
      )

    when "week"

      @leads = @leads.where(
        created_at:
          Time.zone.today.beginning_of_week..
          Time.zone.today.end_of_week
      )

    when "month"

      @leads = @leads.where(
        created_at:
          Time.zone.today.beginning_of_month..
          Time.zone.today.end_of_month
      )

    when "custom"

      if params[:start_date].present? &&
         params[:end_date].present?

        start_date = Date.parse(params[:start_date]) rescue nil
        end_date   = Date.parse(params[:end_date]) rescue nil

        if start_date && end_date

          @leads = @leads.where(
            created_at:
              start_date.beginning_of_day..
              end_date.end_of_day
          )

        end

      end

    end


    # ==================================================
    # KPI
    # ==================================================

    @total_leads = @leads.count

    @open_count =
      @leads.where(status: "open").count

    @converted_count =
      @leads.where(status: "converted").count

    @uncontacted_count =
      @leads.uncontacted.merge(@leads).count

    @closed_count =
      @leads.where.not(
        status: ["open", "converted"]
      ).count


    # ==================================================
    # CONVERSION RATE
    # ==================================================

    @conversion_rate =
      if @total_leads.zero?

        0

      else

        (
          @converted_count.to_f /
          @total_leads *
          100
        ).round(1)

      end


    # ==================================================
    # CONTACTED
    # ==================================================

    @contacted_count =
      @total_leads - @uncontacted_count

    @contacted_rate =
      if @total_leads.zero?

        0

      else

        (
          @contacted_count.to_f /
          @total_leads *
          100
        ).round(1)

      end


    # ==================================================
    # TODAY
    # ==================================================

    @today_count =
      Jmlead.where(
        created_at: Time.zone.today.all_day
      ).count


    # ==================================================
    # STAFF PERFORMANCE
    # ==================================================

    @staff_performance =
      Jstaff
        .where(id: @leads.where.not(jstaff_id: nil).distinct.pluck(:jstaff_id))
        .map do |staff|

        staff_leads =
          @leads.where(jstaff_id: staff.id)

        total = staff_leads.count

        converted =
          staff_leads.where(
            status: "converted"
          ).count

        open =
          staff_leads.where(
            status: "open"
          ).count

        conversion =
          if total.zero?

            0

          else

            (
              converted.to_f /
              total *
              100
            ).round(1)

          end

        {
          staff: staff,
          total: total,
          open: open,
          converted: converted,
          conversion: conversion
        }

      end
        .sort_by { |x| -x[:conversion] }


    # ==================================================
    # DAILY LEADS
    # ==================================================

    @daily_leads =
      @leads
        .group_by { |lead| lead.created_at.to_date }
        .sort
        .map do |date, leads|

        {
          date: date,
          total: leads.count,
          converted: leads.count {
            |lead| lead.status == "converted"
          },
          open: leads.count {
            |lead| lead.status == "open"
          }
        }

      end


    # ==================================================
    # STATUS BREAKDOWN
    # ==================================================

    @status_breakdown =
      @leads
        .group(:status)
        .count
        .sort_by { |_status, count| -count }


    # ==================================================
    # UNCONTACTED AGING
    # ==================================================

    @uncontacted_aging = {

      today: @leads.uncontacted
        .where(
          last_customer_message_at: Time.zone.today.all_day
        )
        .count,

      yesterday: @leads.uncontacted
        .where(
          last_customer_message_at:
            1.day.ago.all_day
        )
        .count,

      "2_3_days": @leads.uncontacted
        .where(
          last_customer_message_at:
            3.days.ago.beginning_of_day..
            2.days.ago.end_of_day
        )
        .count,

      "4_7_days": @leads.uncontacted
        .where(
          last_customer_message_at:
            7.days.ago.beginning_of_day..
            4.days.ago.end_of_day
        )
        .count,

      "8_plus_days": @leads.uncontacted
        .where(
          last_customer_message_at:
            ..8.days.ago.end_of_day
        )
        .count

    }


    # ==================================================
    # TOP ITEMS REQUESTED
    # ==================================================

    @top_items =
      @leads
        .where.not(items_required: [nil, ""])
        .group(:items_required)
        .count
        .sort_by { |_item, count| -count }
        .first(5)


    # ==================================================
    # RECENT LEADS
    # ==================================================

    @recent_leads =
      @leads
        .includes(:jstaff)
        .order(created_at: :desc)
        .limit(5)



# ============================================
# LAST 16 DAYS UNCONTACTED LEADS
# ============================================

@uncontacted_days = (0..5).map do |i|

  date = Date.current - i

  {
    date: date,
    count: Jmlead.uncontacted
                 .where(last_customer_message_at: date.all_day)
                 .count
  }

end

case params[:period]

when "today"
  date = Time.zone.today.strftime("%d %b %Y")

  @jmleads = @jmleads.where(
    "conversation LIKE ? OR conversation LIKE ?",
    "%#{date}%",
    "%Posted: #{date}%"
  )

when "yesterday"
  date = 1.day.ago.strftime("%d %b %Y")

  @jmleads = @jmleads.where(
    "conversation LIKE ? OR conversation LIKE ?",
    "%#{date}%",
    "%Posted: #{date}%"
  )

when "week"

  conditions = []
  values = []

  (Time.zone.today.beginning_of_week..Time.zone.today.end_of_week).each do |day|
    date = day.strftime("%d %b %Y")

    conditions << "(conversation LIKE ? OR conversation LIKE ?)"
    values << "%#{date}%"
    values << "%Posted: #{date}%"
  end

  @jmleads = @jmleads.where(conditions.join(" OR "), *values)

when "month"

  conditions = []
  values = []

  (Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).each do |day|
    date = day.strftime("%d %b %Y")

    conditions << "(conversation LIKE ? OR conversation LIKE ?)"
    values << "%#{date}%"
    values << "%Posted: #{date}%"
  end

  @jmleads = @jmleads.where(conditions.join(" OR "), *values)

when "date"

  if params[:date].present?

    day = Date.parse(params[:date]) rescue nil

    if day

      date = day.strftime("%d %b %Y")

      @jmleads = @jmleads.where(
        "conversation LIKE ? OR conversation LIKE ?",
        "%#{date}%",
        "%Posted: #{date}%"
      )

    end

  end

end

# ==================================================
# MANAGER PERFORMANCE — AUDITED ACTIVITY
# ==================================================

audit_scope =
  Audited::Audit
    .where(auditable_type: "Jmlead")
    .where(created_at: @leads.minimum(:created_at)..Time.current)


@manager_performance = {}

audit_scope.find_each do |audit|

  user = audit.user

  next unless user

  username =
    user.respond_to?(:username) && user.username.present? ?
      user.username :
      user.email

  @manager_performance[username] ||= {
    user: user,
    assigned: 0,
    converted: 0,
    status_changes: 0,
    comments: 0,
    updates: 0,
    total: 0
  }


  row = @manager_performance[username]


  # ================================================
  # TOTAL AUDITED ACTIVITY
  # ================================================

  row[:total] += 1


  # ================================================
  # AUDITED CHANGES
  # ================================================

  changes = audit.audited_changes || {}


  # --------------------------------
  # STATUS
  # --------------------------------

  if changes.key?("status")

    row[:status_changes] += 1

    new_status =
      if changes["status"].is_a?(Array)
        changes["status"].last
      else
        changes["status"]
      end

    if new_status.to_s == "converted"

      row[:converted] += 1

    end

  end


  # --------------------------------
  # STAFF ASSIGNMENT
  # --------------------------------

  if changes.key?("jstaff_id")

    row[:assigned] += 1

  end


  # --------------------------------
  # CONVERSATION / COMMENTS
  # --------------------------------

  if changes.key?("conversation") ||
     changes.key?("comments") ||
     changes.key?("general_comments")

    row[:comments] += 1

  end


  # ================================================
  # OTHER LEAD UPDATES
  # ================================================

  row[:updates] += 1

end


# ==================================================
# SORT MANAGERS
# ==================================================

@manager_performance =
  @manager_performance
    .values
    .sort_by { |row| -row[:total] }




  # =====================================================
# FULFILLMENT MANAGER PERFORMANCE
# =====================================================

start_date = Date.current.beginning_of_month
end_date   = Date.current.end_of_month

@fulfillment_summary = {}

User.joins(:roles)
    .where(roles: { name: %w[manager superadmin] })
    .distinct
    .find_each do |user|

  @fulfillment_summary[user.id] = {
    user: user,
    dispatched: 0,
    delivered: 0,
    refunded: 0,
    total: 0
  }

end


Audited::Audit
  .includes(:user)
  .where(
    auditable_type: "Jfulfillment",
    created_at: start_date..end_date
  )
  .find_each do |audit|


  next unless audit.user
  next unless @fulfillment_summary[audit.user.id]


  next unless audit.audited_changes["status"].present?


  old_status, new_status =
    audit.audited_changes["status"]


  status = new_status.to_s.downcase


  case status

  when "dispatched"

    @fulfillment_summary[audit.user.id][:dispatched] += 1


  when "delivered"

    @fulfillment_summary[audit.user.id][:delivered] += 1


  when "refunded", "refund/cancelled"

    @fulfillment_summary[audit.user.id][:refunded] += 1

  end


  @fulfillment_summary[audit.user.id][:total] += 1

end


@highest_fulfillment =
  @fulfillment_summary.values
    .map { |r| r[:total] }
    .max
    .to_i
  

  # =====================================================
  # MANAGER PERFORMANCE
  # =====================================================

  start_date = @today.beginning_of_month
  end_date   = @today.end_of_month

  @comment_summary = {}

  User.joins(:roles)
      .where(roles: { name: %w[manager superadmin] })
      .distinct
      .find_each do |user|

    @comment_summary[user.id] = {
      user: user,
      comments: 0
    }
  end

  Audited::Audit
    .includes(:user)
    .where(
      auditable_type: "Janomaxlead",
      created_at: start_date..end_date
    )
    .find_each do |audit|

    next unless audit.user
    next unless @comment_summary[audit.user.id]

    next unless audit.audited_changes["comments"].present?

    old_comment, new_comment =
      audit.audited_changes["comments"]

    next if new_comment.blank?

    @comment_summary[audit.user.id][:comments] += 1
  end

  # =====================================================
  # TABLE
  # =====================================================

  @janomaxleads =
    leads.order(last_called_at: :desc)


    # =====================================================
# MANAGER PERFORMANCE
# =====================================================

start_date = Date.current.beginning_of_month
end_date   = Date.current.end_of_month

@comment_summary = {}

User.joins(:roles)
    .where(roles: { name: %w[manager superadmin] })
    .distinct
    .find_each do |user|

  @comment_summary[user.id] = {
    user: user,
    comments_done: 0
  }
end

Audited::Audit
  .includes(:user)
  .where(
    auditable_type: "Janomaxlead",
    created_at: start_date..end_date
  )
  .find_each do |audit|

  next unless audit.user
  next unless @comment_summary[audit.user.id]

  next unless audit.audited_changes["comments"].present?

  old_comment, new_comment =
    audit.audited_changes["comments"]

  next if new_comment.blank?

  @comment_summary[audit.user.id][:comments_done] += 1
end

@highest_comments =
  @comment_summary.values.map { |r| r[:comments_done] }.max.to_i



  





# =====================================================
# MONTHLY AGENT PIVOT TABLE
# =====================================================

@year = params[:year]&.to_i || Date.current.year
@months = Date::MONTHNAMES.compact

@branches =
  Janomaxleadcall
    .where.not(agent: [nil, ""])
    .distinct
    .order(:agent)
    .pluck(:agent)

@pivot_data = @months.map.with_index(1) do |month, idx|

  row = { month: month }

  @branches.each do |agent|

    row[agent] =
      Janomaxleadcall
        .where(agent: agent)
        .where(created_at: Date.new(@year, idx, 1)..Date.new(@year, idx, -1))
        .count

  end

  row

end

@monthly_totals = @pivot_data.map do |row|
  @branches.sum { |a| row[a] || 0 }
end

# =====================================================
# ACTIVE MONTH ANALYSIS
# =====================================================

@active_months_count =
  @monthly_totals
    .select { |total| total.to_i > 0 }
    .count


@overall_monthly_average =
  if @active_months_count > 0
    (@monthly_totals.sum.to_f / @active_months_count).round(1)
  else
    0
  end

@active_branches =
  @branches.select do |agent|
    @pivot_data.any? { |r| (r[agent] || 0) > 0 }
  end

@current_month =
  Janomaxleadcall
    .where(created_at: Date.current.beginning_of_month..Date.current.end_of_month)
    .group(:agent)
    .count

@previous_month =
  Janomaxleadcall
    .where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
    .group(:agent)
    .count


# =====================================================
# MONTHLY BRANCH PERFORMANCE PIVOT
# =====================================================

today = Date.current

@year = params[:year]&.to_i || today.year

@months = Date::MONTHNAMES.compact


# All branches
@branches = Jbranchperformance::BRANCHES



# =====================================================
# MONTHLY DATA
# =====================================================

@pivot_data = @months.map.with_index(1) do |month, index|

  start_date = Date.new(@year, index, 1)
  end_date   = start_date.end_of_month

  row = {
    month: month
  }


  @branches.each do |branch|

    row[branch] =
      Jbranchperformance
        .where(branch: branch)
        .where(record_date: start_date..end_date)
        .sum(:bales_sold)

  end


  row

end





# =====================================================
# MONTHLY TOTALS
# =====================================================

@monthly_totals = @pivot_data.map do |row|

  @branches.sum do |branch|
    row[branch].to_i
  end

end





# =====================================================
# ACTIVE BRANCHES ONLY
# =====================================================

@active_branches =
  @branches.select do |branch|

    @pivot_data.any? do |row|

      row[branch].to_i > 0

    end

  end





# =====================================================
# CURRENT MONTH
# =====================================================

@current_month =
  Jbranchperformance
    .where(
      record_date: today.beginning_of_month..today.end_of_month
    )
    .group(:branch)
    .sum(:bales_sold)




# =====================================================
# PREVIOUS MONTH
# =====================================================

previous_month = today.prev_month


@previous_month =
  Jbranchperformance
    .where(
      record_date: previous_month.beginning_of_month..
                  previous_month.end_of_month
    )
    .group(:branch)
    .sum(:bales_sold)




# =====================================================
# ACTIVE MONTH COUNT
# =====================================================

@active_months_count =
  @monthly_totals
    .select { |x| x.to_i > 0 }
    .count





# =====================================================
# PERFORMANCE SUMMARY
# =====================================================

@total_bales_sold =
  @monthly_totals.sum



@monthly_average =
  if @active_months_count > 0
    (@total_bales_sold.to_f /
     @active_months_count).round(2)
  else
    0
  end




# =====================================================
# BRANCH RANKING
# =====================================================

# =====================================================
# MONTHLY BRANCH PERFORMANCE PIVOT
# =====================================================

today = Date.current

@branch_year = params[:year]&.to_i || today.year
@branch_months = Date::MONTHNAMES.compact
@branch_names = Jbranchperformance::BRANCHES

@branch_pivot_data = @branch_months.map.with_index(1) do |month, index|

  start_date = Date.new(@branch_year, index, 1)

  row = { month: month }

  @branch_names.each do |branch|
    row[branch] =
      Jbranchperformance
        .where(branch: branch)
        .where(record_date: start_date..start_date.end_of_month)
        .sum(:bales_sold)
  end

  row
end


# ==========================================
# PREVIOUS YEAR MONTHLY DATA
# ==========================================

@branch_previous_year = @branch_year - 1

@branch_previous_pivot = @branch_months.map.with_index(1) do |month, index|

  start_date = Date.new(@branch_previous_year, index, 1)

  row = { month: month }

  @branch_names.each do |branch|

    row[branch] =
      Jbranchperformance
        .where(branch: branch)
        .where(record_date: start_date..start_date.end_of_month)
        .sum(:bales_sold)

  end

  row

end

@branch_monthly_totals =
  @branch_pivot_data.map do |row|
    @branch_names.sum { |b| row[b].to_i }
  end

@branch_active_branches =
  @branch_names.select do |branch|
    @branch_pivot_data.any? { |r| r[branch].to_i > 0 }
  end

@branch_current_month =
  Jbranchperformance
    .where(record_date: today.beginning_of_month..today.end_of_month)
    .group(:branch)
    .sum(:bales_sold)

prev = today.prev_month

@branch_previous_month =
  Jbranchperformance
    .where(record_date: prev.beginning_of_month..prev.end_of_month)
    .group(:branch)
    .sum(:bales_sold)

@branch_active_months_count =
  @branch_monthly_totals.count(&:positive?)

@branch_total_bales =
  @branch_monthly_totals.sum

@branch_monthly_average =
  if @branch_active_months_count.zero?
    0
  else
    (@branch_total_bales.to_f / @branch_active_months_count).round(1)
  end

@branch_ranking =
  @branch_active_branches.map do |branch|
    {
      branch: branch,
      total: @branch_pivot_data.sum { |r| r[branch].to_i }
    }
  end.sort_by { |x| -x[:total] }


  # =====================================================
# PERFORMANCE GROWTH TREND (DAILY + CUMULATIVE)
# =====================================================

today = Date.current
previous_month = today.prev_month
previous_two_months = today.prev_month(2)


# Days aligned with current month

@days = (1..today.end_of_month.day).to_a



def build_series(days, base_date, data)

  days.map do |day|

    date = base_date.beginning_of_month + (day - 1).days

    data[date].to_i

  end

end



def cumulative(values)

  total = 0

  values.map do |value|

    total += value

  end

end



# CURRENT MONTH

current_daily =
  Jbranchperformance
    .where(
      record_date:
      today.beginning_of_month..today.end_of_month
    )
    .group(:record_date)
    .sum(:bales_sold)



# LAST MONTH

previous_daily =
  Jbranchperformance
    .where(
      record_date:
      previous_month.beginning_of_month..
      previous_month.end_of_month
    )
    .group(:record_date)
    .sum(:bales_sold)



# TWO MONTHS AGO

prev2_daily =
  Jbranchperformance
    .where(
      record_date:
      previous_two_months.beginning_of_month..
      previous_two_months.end_of_month
    )
    .group(:record_date)
    .sum(:bales_sold)



# DAILY SERIES

@current_series =
  build_series(
    @days,
    today,
    current_daily
  )


@previous_series =
  build_series(
    @days,
    previous_month,
    previous_daily
  )


@prev2_series =
  build_series(
    @days,
    previous_two_months,
    prev2_daily
  )




# CUMULATIVE

@current_cumulative =
  cumulative(@current_series)


@previous_cumulative =
  cumulative(@previous_series)


@prev2_cumulative =
  cumulative(@prev2_series)




# KPI GROWTH

current_total =
  @current_cumulative.last.to_i


previous_total =
  @previous_cumulative.last.to_i



@growth_percentage =

if previous_total > 0

  (((current_total - previous_total).to_f /
    previous_total) * 100).round(1)

else

  0

end


  @joutputs = Joutput.all

  # Build lookup { [2025,"Jan"] => qty, ... }
  grouped = @joutputs.group(:year, :month).sum(:qty)

  # Build pivot table for the HTML table
  @pivot_data = Joutput::MONTHS.map do |month|
    row = { month: month }
    Joutput::YEARS.each do |yr|
      row[yr] = grouped[[yr, month]] || 0
    end
    row
  end

  # Build outputs_data for chart
  @outputs_data = {}
  Joutput::YEARS.each do |yr|
    @outputs_data[yr] = Joutput::MONTHS.index_with do |m|
      grouped[[yr, m]] || 0
    end
  end


  end





end