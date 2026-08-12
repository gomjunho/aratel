class ConciergeReservation < ApplicationRecord
  belongs_to :user, optional: true
  validates :reservation_id, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["assigned_consultant", "created_at", "id", "notes", "preferred_date", "reservation_id", "service_type", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
