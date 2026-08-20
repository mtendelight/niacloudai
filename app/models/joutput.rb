class Joutput < ApplicationRecord
  validates :year, presence: true, inclusion: { in: [2025, 2026, 2027, 2028] }
  validates :month, presence: true, uniqueness: { scope: :year, message: "already has an entry for this year" }
  validates :qty, presence: true, numericality: { greater_than_or_equal_to: 0 }

  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  YEARS  = [2025, 2026, 2027, 2028].freeze

  def self.month_options
    MONTHS.map { |m| [m, m] }
  end

  def self.year_options
    YEARS.map { |y| [y, y] }
  end

  
end
