class Status < ApplicationRecord
	has_many :tickets
	  has_many :locs
end
