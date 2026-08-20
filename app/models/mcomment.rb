class Mcomment < ApplicationRecord
    belongs_to :project
  belongs_to :user, optional: true

  validates :content, presence: true
end
