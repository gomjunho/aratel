require "test_helper"

class ClubDealTest < ActiveSupport::TestCase
  test "valid club deal format as json" do
    deal = club_deals(:one)
    json = deal.as_api_json

    assert_equal "deal_552", json[:id]
    assert_equal "B&B Italia", json[:brand]
    assert_equal "Camaleonda Sofa VVIP Club Deal", json[:item_name]
    assert_equal 18500000, json[:original_price]
    assert_equal 14200000, json[:deal_price]
    assert_equal 1000000, json[:point_discount_limit]
    assert_equal 5, json[:min_participants]
    assert_equal 3, json[:current_participants]
    assert_equal "OPEN", json[:status]
  end

  test "validates required fields" do
    deal = ClubDeal.new
    assert_not deal.valid?
    assert_includes deal.errors[:deal_id], "can't be blank"
    assert_includes deal.errors[:brand], "can't be blank"
    assert_includes deal.errors[:item_name], "can't be blank"
    assert_includes deal.errors[:original_price], "can't be blank"
    assert_includes deal.errors[:deal_price], "can't be blank"
  end
end
