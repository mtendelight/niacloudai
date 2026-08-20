# app/services/jmlead_service.rb

class JmleadService
  def self.sync(customer:, conversation:)
    items = conversation.summary.presence ||
            conversation.aimessages.where(role: "user").pluck(:content).join("\n")

    lead = Jmlead.find_or_initialize_by(phone: customer.phone)

    lead.name = customer.name if customer.name.present?
    lead.items_required = items.truncate(500)
    lead.comments = conversation.aimessages
                                .order(:created_at)
                                .pluck(:role, :content)
                                .map { |r, c| "#{r}: #{c}" }
                                .join("\n\n")

    lead.status ||= "open"

    lead.save!
  end
end