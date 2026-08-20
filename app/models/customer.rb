class Customer < ApplicationRecord
   before_create :set_default_quantity

  audited
 def next_payment_date
    return nil unless payment_date.present?

    next_date = payment_date
    case payment_duration.downcase  # Remove .name
    when 'monthly'
      next_date += 1.month
    when 'quarterly'
      next_date += 3.months
    when 'yearly'
      next_date += 1.year
    end
    next_date
  end

    private

  def set_default_quantity
    self.quantity ||= 1
  end
end
