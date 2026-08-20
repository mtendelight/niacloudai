class Jbranchperformance < ApplicationRecord
  BRANCHES = [
    "Kitale",
    "Eldoret",
    "Mombasa",
    "Kisumu",
    "Naks",
    "Bungoma",
    "Meru",
    "Kisii",
    "Household",
    "Nairobi",
    "Online"
  ].freeze

  validates :branch, presence: true, inclusion: { in: BRANCHES }
  validates :bales_sold, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :record_date, presence: true

  validates :record_date, uniqueness: { scope: :branch }
end
