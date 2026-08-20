class AilogsController < ApplicationController
  # GET /ailogs
def index
  per_page = params[:per_page].presence.to_i
  per_page = 5 if per_page.zero?

  base = Ailog.unscoped

  # Search
  if params[:search].present?
    search = "%#{params[:search].strip}%"

    base = base.where(
      "customer_name ILIKE :search
       OR phone ILIKE :search
       OR message ILIKE :search",
      search: search
    )
  end

  # Latest record id for each phone
  latest_ids = base
                 .reorder(nil)
                 .group(:phone)
                 .pluck(Arel.sql("MAX(id)"))

  # Customers (one per phone)
@logs = base
          .where(id: latest_ids)
          .order(updated_at: :desc)
          .page(params[:page])
          .per(per_page)

          @logs.each do |log|
  log.define_singleton_method(:jmlead) do
    Jmlead.find_by(phone: phone) ||
      Jmlead.find_by(phone: phone.to_s.gsub("+254", "0")) ||
      Jmlead.find_by(phone: "+254#{phone.to_s.sub(/^0/, '')}")
  end
end

# Last messages for each customer
phones = @logs.pluck(:phone)

# Load lead phones once
lead_phones = Jmlead.pluck(:phone)
                  .map { |p| Jmlead.normalize_phone(p) }

@recent_messages = {}

phones.each do |phone|

  normalized_phone = Jmlead.normalize_phone(phone)

  limit_count = lead_phones.include?(normalized_phone) ? 3 : 6

  @recent_messages[phone] = base
                              .where(phone: phone)
                              .order(updated_at: :desc)
                              .limit(limit_count)
                              .to_a
                              .reverse

end

  # Export
  @logsa = base.order(updated_at: :desc)

  respond_to do |format|
    format.html

    format.csv do
      send_data(
        Ailog.to_csv(@logsa),
        filename: "ailogs_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
      )
    end

    format.xlsx do
      response.headers["Content-Disposition"] =
        "attachment; filename=ailogs_#{Time.current.strftime('%Y%m%d_%H%M%S')}.xlsx"
    end

    format.js
  end
end
end