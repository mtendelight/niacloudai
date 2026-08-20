module TicketStatusScopes
  extend ActiveSupport::Concern

  OPEN_STATUS = [nil, ""].freeze
  CLOSED_STATUS = ["CLOSED", "CLOSED DIRECTLY"].freeze

  ON_HOLD_REASONS = [
    "NOT FIBER READY",
    "CLIENT TO CONFIRM AVAILABILITY",
    "AWAITING ONT",
    "AWAITING ACCESS LETTER",
    "NEED POLES",
    "SOLD OUTSIDE COVERAGE",
    "ROUTE CHALLENGE",
    "OTHER SPECIAL REASONS",
    "UNDER CONSTRUCTION",
    "AWAITING SAFARICOM APPROVAL",
    "MANAGEMENT ISSUES",
    "AWAITING SIGNAL PROVISIONING",
    "NEED CAPACITY/INFRASTRUCTURE EXPANSION",
    "CLIENT REQUEST REFUND",
    "CLIENT UNREACHABLE/NOT PICKING CALLS",
    "WRONG MOBILE NUMBER",
    "WRONG ADDRESS",
    "OUTSIDE FIRESIDE JURISDICTION"
  ].freeze

  included do
    scope :open, -> { where(status_id: OPEN_STATUS) }

    scope :closed, -> { where(status_id: CLOSED_STATUS) }

    scope :closed_today, -> {
      where(status_id: CLOSED_STATUS)
      .where(updated_at: Time.zone.today.all_day)
    }

    scope :scheduled, -> {
      where(reason_id: [nil, "", "SCHEDULED"])
    }

    scope :rescheduled_today, -> {
      where(reason_id: "RESCHEDULED TO A LATER DATE")
        .where(planned_date: Time.zone.today.all_day)
    }

    scope :on_hold, -> {
      where(reason_id: ON_HOLD_REASONS)
    }
  end
end