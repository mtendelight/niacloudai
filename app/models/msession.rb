class Msession < ApplicationRecord
	  belongs_to :mbooking

	  before_create :generate_session_number

def generate_session_number
  self.session_number = "MS-#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(2).upcase}"
end

def duration_display
  duration_minutes.present? ? "#{duration_minutes} mins" : "N/A"
end


before_validation :set_default_status, on: :create

def set_default_status
  self.status ||= "Scheduled"
end
end
