class UserSession < ApplicationRecord
	
before_commit  :remove_all

	def remove_all
		if UserSession.where('updated_at < ?', 1.hour.ago).exists?

  UserSession.destroy_all
  
  end



 
end



end
