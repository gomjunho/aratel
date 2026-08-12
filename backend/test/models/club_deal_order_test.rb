require "test_helper"

class ClubDealOrderTest < ActiveSupport::TestCase
  test "valid order sets order_id and defaults" do
    order = ClubDealOrder.new(
      club_deal_id: "deal_552",
      used_points: 500000,
      cash_amount: 13700000
    )

    assert order.valid?
    assert_not_nil order.order_id
    assert order.order_id.start_with?("ord_")
    assert_equal "ORDER_PLACED", order.status
    assert_equal 450000, order.remaining_points
  end

  test "invalid without used_points or cash_amount" do
    order = ClubDealOrder.new(club_deal_id: "deal_552")
    assert_not order.valid?
    assert_includes order.errors[:used_points], "can't be blank"
    assert_includes order.errors[:cash_amount], "can't be blank"
  end

  test "as_created_json returns expected order output" do
    order = ClubDealOrder.new(
      order_id: "ord_9901",
      club_deal_id: "deal_552",
      used_points: 500000,
      cash_amount: 13700000
    )
    json = order.as_created_json

    assert_equal "ord_9901", json[:order_id]
    assert_equal "ORDER_PLACED", json[:status]
    assert_equal 450000, json[:remaining_points]
  end
end
