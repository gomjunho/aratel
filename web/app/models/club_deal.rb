class ClubDeal < ApplicationRecord
  validates :deal_id, presence: true, uniqueness: true
end
