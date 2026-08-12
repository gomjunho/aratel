require "securerandom"

class DelegatedAccess < ApplicationRecord
  validates :relationship, presence: true
  validates :document_url, presence: true
  validates :delegation_id, presence: true, uniqueness: true

  before_validation :set_defaults

  def approve!(approved)
    if approved
      update!(
        status: "APPROVED",
        granted_badge: "RESIDENT",
        role: "RESIDENT"
      )
    else
      update!(
        status: "REJECTED",
        granted_badge: nil,
        role: nil
      )
    end
  end

  private

  def set_defaults
    self.delegation_id = "del_#{rand(1000..9999)}" if delegation_id.blank?
    self.status ||= "PENDING_OWNER_APPROVAL"
    self.requested_at ||= Time.current
  end
end
