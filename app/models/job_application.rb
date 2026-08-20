class JobApplication < ApplicationRecord
  belongs_to :talent
  belongs_to :openjob

  validates :talent_id, uniqueness: { scope: :openjob_id, message: "already applied for this job" }

  STATUSES = %w[pending shortlisted rejected hired]

  validates :status, inclusion: { in: STATUSES }, allow_nil: true

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= "pending"
  end
end