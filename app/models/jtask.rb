class Jtask < ApplicationRecord
	validates :title, presence: true
  validates :status, inclusion: { in: %w[Pending InProgress Completed], allow_blank: true }
  validates :priority, inclusion: { in: %w[High Medium Low], allow_blank: true }

    scope :completed, -> { where(done: true) }
  scope :active, -> { where.not(done: true) }
end
