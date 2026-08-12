class ClubDealOrder < ApplicationRecord
  belongs_to :user, optional: true
  validates :order_id, presence: true, uniqueness: true
end
