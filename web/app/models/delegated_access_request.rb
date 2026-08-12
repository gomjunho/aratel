class DelegatedAccessRequest < ApplicationRecord
  belongs_to :user

  validates :relationship, presence: true
  validates :document_url, presence: true
  validates :delegation_id, presence: true

  before_validation :set_defaults, if: :new_record?

  def set_defaults
    self.delegation_id ||= "del_#{SecureRandom.hex(4)}"
    self.status ||= "PENDING_OWNER_APPROVAL"
    self.requested_at ||= Time.current
  end

  def approve!
    self.status = "APPROVED"
    self.granted_badge = "RESIDENT"
    self.role = "RESIDENT"
    user.add_badge("RESIDENT")
    user.save!
    save!
  end

  def reject!
    self.status = "REJECTED"
    save!
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "delegation_id", "document_url", "id", "relationship", "role", "granted_badge", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
