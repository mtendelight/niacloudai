class ApplicationRecord < ActiveRecord::Base
 



  self.abstract_class = true

  def minutes_to_human(minutes)
  result = {}

  hours = minutes / 60
  result[:hours] = hours if hours.positive?
  result[:minutes] = ((minutes * 60) - (hours * 60 * 60)) / 60 if minutes % 60 != 0

  result[:minutes] /= 60.0 if result.key?(:hours) && result.key?(:minutes)

  return I18n.t('helper.minutes_to_human.hours_minutes', time: (result[:hours] + result[:minutes]).round(2)) if result.key?(:hours) && result.key?(:minutes)
  return I18n.t('helper.minutes_to_human.hours', count: result[:hours]) if result.key?(:hours)
  return I18n.t('helper.minutes_to_human.minutes', count: result[:minutes].round) if result.key?(:minutes)
  ''
end


attr_accessor :is_importing

end
