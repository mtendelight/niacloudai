class Aiconversation < ApplicationRecord
  belongs_to :aicustomer

  has_many :aimessages, dependent: :destroy
end
