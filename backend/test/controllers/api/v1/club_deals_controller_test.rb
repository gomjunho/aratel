require "test_helper"

class Api::V1::ClubDealsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/club_deals returns list of club deals" do
    get "/api/v1/club_deals"

    assert_response :success
    json = JSON.parse(response.body)

    assert_kind_of Array, json["club_deals"]
    assert_not_empty json["club_deals"]

    deal = json["club_deals"].first
    assert_equal "deal_552", deal["id"]
    assert_equal "B&B Italia", deal["brand"]
    assert_equal "Camaleonda Sofa VVIP Club Deal", deal["item_name"]
    assert_equal 18500000, deal["original_price"]
    assert_equal 14200000, deal["deal_price"]
    assert_equal 1000000, deal["point_discount_limit"]
    assert_equal 5, deal["min_participants"]
    assert_equal 3, deal["current_participants"]
    assert_equal "OPEN", deal["status"]
  end

  test "POST /api/v1/club_deals/:id/order with valid params creates order" do
    post "/api/v1/club_deals/deal_552/order", params: {
      used_points: 500000,
      cash_amount: 13700000
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)

    assert json["order_id"].start_with?("ord_")
    assert_equal "ORDER_PLACED", json["status"]
    assert_equal 450000, json["remaining_points"]
  end

  test "POST /api/v1/club_deals/:id/order with non-existent deal returns 404" do
    post "/api/v1/club_deals/deal_invalid/order", params: {
      used_points: 500000,
      cash_amount: 13700000
    }, as: :json

    assert_response :not_found
    json = JSON.parse(response.body)

    assert_equal "error", json["status"]
    assert_equal ["Club deal not found"], json["errors"]
  end

  test "POST /api/v1/club_deals/:id/order with missing params returns 422" do
    post "/api/v1/club_deals/deal_552/order", params: {
      used_points: nil,
      cash_amount: nil
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)

    assert_equal "error", json["status"]
    assert_not_nil json["errors"]
  end
end
