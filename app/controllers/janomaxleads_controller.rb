class JanomaxleadsController < ApplicationController
  before_action :set_janomaxlead, only: %i[ show edit update destroy ]

def index
  per_page = (params[:per_page] || 10).to_i

  # Base relation (prevents N+1)
  @janomaxleads = Janomaxlead.includes(:jmcustomer)

  # =========================
  # FILTERS
  # =========================
  if params[:status].present?
    @janomaxleads = @janomaxleads.where(lead_status: params[:status])
  end

  if params[:existing].present?
    @janomaxleads = @janomaxleads.where(customer_exists: true)
  end

  # =========================
  # SEARCH
  # =========================
  if params[:q].present?
    query = params[:q].strip

    @janomaxleads = @janomaxleads
                      .left_joins(:jmcustomer)
                      .where(
                        "janomaxleads.phone ILIKE :q
                         OR janomaxleads.lead_status ILIKE :q
                         OR jmcustomers.name ILIKE :q",
                        q: "%#{query}%"
                      )
                      .distinct
  end

  # =========================
  # SORTING
  # =========================
if params[:sort] == "calls_desc"

  @janomaxleads = @janomaxleads
                    .where(lead_status: "open")
                    .where.not(comments: [nil, ""])
                    .reorder(
                      Arel.sql("
                        updated_at DESC,
                        calls_count DESC
                      ")
                    )

  elsif params[:status] == "open"

    @janomaxleads = @janomaxleads
                      .reorder(
                        Arel.sql("
                          CASE
                            WHEN TRIM(COALESCE(comments,'')) = '' THEN 0
                            ELSE 1
                          END ASC,
                          COALESCE(last_called_at, created_at) ASC
                        ")
                      )

  else

    @janomaxleads = @janomaxleads.order(updated_at: :desc)

  end


# ============================================
# LAST 16 DAYS FOLLOW-UP COUNTS
# Only display days that have follow-ups
# ============================================

@followup_days = (0..29).filter_map do |i|

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

  # Skip days with no follow-ups
  next if count.zero?

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
  # =========================
  # KPI COUNTS
  # =========================
  @unique_leads       = Janomaxlead.count
  @open_leads         = Janomaxlead.where(lead_status: "open").count
  @converted          = Janomaxlead.where(lead_status: "converted").count
  @existing_customers = Janomaxlead.where(customer_exists: true).count

  respond_to do |format|
    format.html do
      @janomaxleads = @janomaxleads
                        .page(params[:page])
                        .per(per_page)
    end

    format.csv do
      send_data(
        Janomaxlead.to_csv(@janomaxleads),
        filename: "janomax_leads_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
      )
    end
  end
end
# GET /janomaxleads/1
def show
  @janomaxlead = Janomaxlead
                   .includes(jmcustomer: :jmpayments)
                   .find(params[:id])

  @lead      = @janomaxlead
  @customer  = @lead.jmcustomer
  @payments  = @customer&.jmpayments&.order(created_at: :desc) || []

  @calls = @lead.janomaxleadcalls.order(called_at: :desc)

  # PaperTrail audits
  audits = @lead.audits.map do |audit|
    {
      type: :audit,
      time: audit.created_at,
      record: audit
    }
  end

  # Inbound calls
  inbound = @lead.janomaxleadcalls.map do |call|
    {
      type: :inbound,
      time: call.called_at,
      record: call
    }
  end

  # Outbound calls
  outbound = @lead.janomax_outbound_calls.map do |call|
    {
      type: :outbound,
      time: call.called_at,
      record: call
    }
  end

  @activity = (audits + inbound + outbound)
                .sort_by { |e| e[:time] || Time.at(0) }
                .reverse
end


def import
  if params[:file].blank?
    redirect_back fallback_location: dashboard_janomaxleads_path,
                  alert: "Please choose a file."
    return
  end

  Janomaxlead.import(params[:file])

  redirect_to dashboard_janomaxleads_path,
              notice: "CDR imported successfully."
end



def activity_timeline
  inbound = janomaxleadcalls.map do |call|
    {
      type: "inbound_call",
      time: call.called_at,
      data: call
    }
  end

  outbound = janomax_outbound_calls.map do |call|
    {
      type: "outbound_call",
      time: call.called_at,
      data: call
    }
  end

  comments = []

  if self.comments.present?
    comments << {
      type: "comment",
      time: updated_at,
      data: comments
    }
  end

  (inbound + outbound + comments)
    .compact
    .sort_by { |x| x[:time] }
    .reverse
end


def dashboard
  check_sms_balance
  leads = Janomaxlead.all
  calls = Janomaxleadcall.all

  # =========================
  # FILTERS
  # =========================
  if params[:status].present?
    leads = leads.where(lead_status: params[:status])
  end

  if params[:existing].present?
    leads = leads.where(customer_exists: true)
  end


# ============================================
# LAST 16 DAYS FOLLOW-UP COUNTS
# Only display days that have follow-ups
# ============================================

@followup_days = (0..29).filter_map do |i|

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

  # Skip days with no follow-ups
  next if count.zero?

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

# ============================================
# COMMENT PERFORMANCE SUMMARY
# ============================================

start_date = Date.current.beginning_of_month
end_date   = Date.current.end_of_month

@comment_summary = {}

# ONLY MANAGERS + SUPERADMINS
User.joins(:roles)
    .where(roles: { name: %w[manager superadmin] })
    .distinct
    .each do |user|

  @comment_summary[user.id] = {
    user: user,
    comments_done: 0
  }
end

Audited::Audit
  .includes(:user)
  .where(auditable_type: "Janomaxlead")
  .where(created_at: start_date..end_date)
  .find_each do |audit|

  next unless audit.user
  next unless @comment_summary.key?(audit.user.id)

  # ONLY COMMENTS CHANGES
  next unless audit.audited_changes["comments"].present?

  old_comment, new_comment =
    audit.audited_changes["comments"]

  # IGNORE BLANK COMMENTS
  next if new_comment.blank?

  @comment_summary[audit.user.id][:comments_done] += 1
end





  # =========================
  # KPIs (GLOBAL - NOT FILTERED)
  # =========================
  @total_calls        = calls.count
  @unique_leads       = Janomaxlead.count
  @open_leads         = Janomaxlead.where(lead_status: "open").count
  @converted          = Janomaxlead.where(lead_status: "converted").count
  @existing_customers = Janomaxlead.where(customer_exists: true).count
  @new_leads          = Janomaxlead.where(customer_exists: false).count
  @max_open_lead_calls = Janomaxlead
                         .where(lead_status: "open")
                         .maximum(:calls_count) || 0

  @answered_calls  = calls.where(status: "ANSWERED").count
  @abandoned_calls = calls.where(status: "ABANDONED").count
  @busy_calls      = calls.where(status: "BUSY").count
  @failed_calls    = calls.where(status: "FAILED").count
  @voicemail_calls = calls.where(status: "VOICEMAIL").count


  @conversion_rate =
  @unique_leads.to_i > 0 ?
    ((@converted.to_f / @unique_leads) * 100).round :
    0

    @new_converted_today =
  Janomaxlead.where(lead_status: "converted")
             .where(created_at: Date.current.all_day)
             .count

    @latest_conversions =
  Janomaxlead.where(lead_status: "converted")
             .order(updated_at: :desc)
             .limit(10)


             today = Date.current
yesterday = today - 1
day_before = today - 2

@today_calls =
  Janomaxleadcall.where(created_at: today.all_day).count

@yesterday_calls =
  Janomaxleadcall.where(created_at: yesterday.all_day).count

@day_before_calls =
  Janomaxleadcall.where(created_at: day_before.all_day).count

@today_unique =
  Janomaxlead.where(created_at: today.all_day).count

@yesterday_unique =
  Janomaxlead.where(created_at: yesterday.all_day).count

@day_before_unique =
  Janomaxlead.where(created_at: day_before.all_day).count

@today_converted =
  Janomaxlead.where(
    lead_status: "converted",
    updated_at: today.all_day
  ).count

@yesterday_converted =
  Janomaxlead.where(
    lead_status: "converted",
    updated_at: yesterday.all_day
  ).count

@day_before_converted =
  Janomaxlead.where(
    lead_status: "converted",
    updated_at: day_before.all_day
  ).count


  @daily_calls = Janomaxleadcall
                 .group_by_day(:created_at, last: 30)
                 .count

@daily_conversions = Janomaxlead
                       .where(lead_status: "converted")
                       .group_by_day(:updated_at, last: 30)
                       .count


  today = Date.current

current_month = today.beginning_of_month
prev1_month   = 1.month.ago.beginning_of_month
prev2_month   = 2.months.ago.beginning_of_month

days_in_month = today.end_of_month.day

@days = (1..days_in_month).to_a

def daily_series(scope, start_date, days)
  (1..days).map do |day|
    date = start_date.change(day: day) rescue nil

    if date && date.month == start_date.month
      scope.where(created_at: date.all_day).count
    else
      0
    end
  end
end

# Calls
@current_daily = daily_series(
  Janomaxleadcall,
  current_month,
  days_in_month
)

@prev1_daily = daily_series(
  Janomaxleadcall,
  prev1_month,
  days_in_month
)

@prev2_daily = daily_series(
  Janomaxleadcall,
  prev2_month,
  days_in_month
)

curr_total  = @current_daily.sum
prev1_total = @prev1_daily.sum
prev2_total = @prev2_daily.sum

@growth_1 =
  prev1_total.zero? ? 0 :
  (((curr_total - prev1_total).to_f / prev1_total) * 100).round

@growth_2 =
  prev2_total.zero? ? 0 :
  (((prev1_total - prev2_total).to_f / prev2_total) * 100).round

  @no_answer_calls =
    calls.where("UPPER(status) LIKE ?", "%NO ANSWER%").count

  # =========================
  # DASHBOARD TABLE DATA (FILTERED)
  # =========================
  @janomaxleads = leads
                    .includes(:jmcustomer)
                    .order(last_called_at: :desc)
end

  # GET /janomaxleads/new
  def new
    @janomaxlead = Janomaxlead.new
  end

  # GET /janomaxleads/1/edit
  def edit
  end

  # POST /janomaxleads or /janomaxleads.json
  def create
    @janomaxlead = Janomaxlead.new(janomaxlead_params)

    respond_to do |format|
      if @janomaxlead.save
        format.html { redirect_to @janomaxlead, notice: "Janomaxlead was successfully created." }
        format.json { render :show, status: :created, location: @janomaxlead }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @janomaxlead.errors, status: :unprocessable_content }
      end
    end
  end

 # PATCH/PUT /janomaxleads/1
def update
  @janomaxlead = Janomaxlead.find(params[:id])

  new_comment = params.dig(:janomaxlead, :comments).to_s.strip

  if new_comment.present?
    handled_at = Time.current
    timestamp  = handled_at.strftime("%d %b %Y %H:%M")
    user       = current_user&.username || "System"

    entry = "💬 [#{timestamp} - #{user}] #{new_comment}"

    @janomaxlead.comments = [
      @janomaxlead.comments,
      entry
    ].compact.join("\n\n")

    @janomaxlead.last_handled_at = handled_at
  end

  respond_to do |format|
    if @janomaxlead.save

      format.html do
        redirect_back(
          fallback_location: janomaxleads_path,
          notice: "Lead updated successfully",
          status: :see_other
        )
      end

      format.json do
        render :show,
               status: :ok,
               location: @janomaxlead
      end

      format.turbo_stream

    else

      format.html do
        render :edit,
               status: :unprocessable_entity
      end

      format.json do
        render json: @janomaxlead.errors,
               status: :unprocessable_entity
      end

    end
  end
end
  # DELETE /janomaxleads/1 or /janomaxleads/1.json
  def destroy
    @janomaxlead.destroy!

    respond_to do |format|
      format.html { redirect_to janomaxleads_path, notice: "Janomaxlead was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
   def set_janomaxlead
  @janomaxlead = Janomaxlead.find(params[:id])
end
    # Only allow a list of trusted parameters through.
   def janomaxlead_params
  params.require(:janomaxlead).permit(
    :phone,
    :last_status,
    :calls_count,
    :lead_status,
    :comments,
    :customer_exists,
    :last_called_at,
    :jmcustomer_id
  )
end
end
