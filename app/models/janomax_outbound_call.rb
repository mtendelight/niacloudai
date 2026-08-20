class JanomaxOutboundCall < ApplicationRecord
  belongs_to :janomaxlead

  validates :called_at, presence: true
  validates :status, presence: true

  before_validation :normalize_called_at

  private

  def normalize_called_at
    return if called_at.blank?

    self.called_at =
      called_at.is_a?(String) ?
      Time.zone.parse(called_at) :
      called_at
  rescue
    self.called_at = nil
  end
end