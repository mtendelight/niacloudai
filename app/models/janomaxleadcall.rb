class Janomaxleadcall < ApplicationRecord
  belongs_to :janomaxlead

  # ----------------------------
  # VALIDATIONS (SAFE VERSION)
  # ----------------------------
  validates :called_at, presence: true
  validates :status, presence: true, allow_blank: false

  # ----------------------------
  # NORMALIZATION (IMPORTANT)
  # ----------------------------
  before_validation :normalize_called_at

  def normalize_called_at
    return if called_at.blank?
    self.called_at = called_at.is_a?(String) ? Time.zone.parse(called_at) : called_at
  rescue
    self.called_at = nil
  end
end