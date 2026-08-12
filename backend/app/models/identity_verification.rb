require "securerandom"

class IdentityVerification < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :birth_date, presence: true
  validates :verification_token, presence: true, uniqueness: true

  before_validation :set_defaults

  private

  def set_defaults
    self.verification_token = "ver_tok_#{SecureRandom.hex(4)}" if verification_token.blank?
    self.masked_name = User.mask_name(name) if masked_name.blank?
    self.status ||= "success"
    self.verified_at ||= Time.current
  end
end
