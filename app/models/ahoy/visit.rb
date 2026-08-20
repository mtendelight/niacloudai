class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"
  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true


  before_commit  :remove_all

  def remove_all
    if Ahoy::Visit.where('started_at < ?', 1.minute.ago).exists?

  Ahoy::Visit.destroy_all
  
  end
end

end
