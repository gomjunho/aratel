class ClubDealOrder < ApplicationRecord
  validates :order_id, presence: true, uniqueness: true
  validates :club_deal_id, presence: true
  validates :used_points, presence: true
  validates :cash_amount, presence: true

  before_validation :set_defaults

  def as_created_json
    {
      order_id: order_id,
      status: status,
      remaining_points: remaining_points
    }
  end

  private

  def set_defaults
    self.order_id ||= "ord_#{rand(9000..9999)}"
    self.status ||= "ORDER_PLACED"
    self.remaining_points ||= 450000
  end
end
