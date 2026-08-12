class ConciergeReservation < ApplicationRecord
  belongs_to :user, optional: true
  validates :reservation_id, presence: true, uniqueness: true
end
