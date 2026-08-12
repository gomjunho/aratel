class TrustApiSync < ApplicationRecord
  validates :verification_token, presence: true
  validates :complex_name, presence: true
  validates :building_number, presence: true
  validates :unit_number, presence: true

  before_validation :set_defaults

  private

  def set_defaults
    self.status ||= "VERIFIED"
    self.ownership_percentage ||= 100
    self.badge ||= "VERIFIED_OWNER"
    self.assigned_tier ||= "GOLD"
    self.verified_at ||= Time.current
  end
end
