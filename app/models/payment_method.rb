class PaymentMethod < ApplicationRecord
	  has_many :expenditures

  validates :name, presence: true, uniqueness: true

end
