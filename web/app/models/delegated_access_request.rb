class DelegatedAccessRequest < ApplicationRecord
  belongs_to :user

  before_validation :generate_delegation_id, on: :create
  before_validation :set_defaults, on: :create

  def generate_delegation_id
    self.delegation_id ||= "del_#{rand(1000..9999)}"
  end

  def set_defaults
    self.status ||= "PENDING_OWNER_APPROVAL"
    self.requested_at ||= Time.current
  end

  def approve!
    update!(
      status: "APPROVED",
      granted_badge: "RESIDENT",
      role: "RESIDENT"
    )
    user.add_badge("RESIDENT")
    user.save!
  end

  def reject!
    update!(status: "REJECTED")
  end
end
