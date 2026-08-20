class JmcustomerItem < ApplicationRecord
  belongs_to :jmcustomer, touch: true
  belongs_to :janomax
  

   after_create :award_points

  # Touch parent only if the child is persisted and parent exists
  after_commit :touch_parent, on: [:create, :update, :destroy]

  private

  def touch_parent
    return unless jmcustomer.present? && persisted? && !destroyed?
    jmcustomer.touch
  end

   def award_points
    jmcustomer.increment!(:points, 150) # change value as needed
  end
end
