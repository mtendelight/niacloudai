class Payment < ApplicationRecord
	 validates :transaction_id, :mpesa_code, :amount, :name, :phone_number, :posted_at, presence: true
end
