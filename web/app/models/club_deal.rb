class ClubDeal < ApplicationRecord
  validates :deal_id, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "created_at", "current_participants", "deal_id", "deal_price", "id", "item_name", "min_participants", "original_price", "point_discount_limit", "status", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
