class Aicustomer < ApplicationRecord
	 has_many :aiconversations, dependent: :destroy
end
