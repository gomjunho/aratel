class ClubDeal < ApplicationRecord
  validates :deal_id, presence: true, uniqueness: true
  validates :brand, presence: true
  validates :item_name, presence: true
  validates :original_price, presence: true
  validates :deal_price, presence: true

  def as_api_json
    {
      id: deal_id,
      brand: brand,
      item_name: item_name,
      original_price: original_price,
      deal_price: deal_price,
      point_discount_limit: point_discount_limit,
      min_participants: min_participants,
      current_participants: current_participants,
      status: status
    }
  end
end
