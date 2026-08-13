require "test_helper"

class ClubDealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    post demo_login_path(user_id: @user.id)
    @deal = ClubDeal.create!(
      deal_id: "deal_552",
      brand: "B&B Italia",
      item_name: "Camaleonda Sofa VVIP Club Deal",
      original_price: 18500000,
      deal_price: 14200000,
      point_discount_limit: 1000000,
      min_participants: 5,
      current_participants: 3,
      status: "OPEN"
    )
  end

  test "should get index view" do
    get club_deals_path
    assert_response :success
    assert_select "h1", text: /클럽 딜/
    assert_select "div", text: /Camaleonda Sofa VVIP Club Deal/
  end

  test "should get index view when no club deals exist" do
    ClubDeal.destroy_all
    get club_deals_path
    assert_response :success
    assert_select "div", text: /Camaleonda Sofa VVIP Club Deal/
  end

  test "should get show view" do
    get club_deal_path(@deal.deal_id)
    assert_response :success
    assert_select ".order-lifecycle-stepper"
    assert_select ".point-calculator-slider"
    assert_select ".live-countdown-banner"
    assert_select "h2", text: /Camaleonda Sofa VVIP Club Deal/
  end

  test "should place order via web" do
    assert_difference("ClubDealOrder.count", 1) do
      post order_club_deal_path(@deal.deal_id), params: { used_points: 500000, cash_amount: 13700000 }
    end
    assert_redirected_to club_deal_path(@deal.deal_id)
    follow_redirect!
    assert_select "div", text: /주문이 성공적으로 접수되었습니다/
  end

  test "should return api club deals" do
    get api_v1_club_deals_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_kind_of Array, json["club_deals"]
    assert_equal "deal_552", json["club_deals"].first["id"]
  end

  test "should return api club deals when empty" do
    ClubDeal.destroy_all
    get api_v1_club_deals_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "deal_552", json["club_deals"].first["id"]
  end

  test "should place order via api" do
    assert_difference("ClubDealOrder.count", 1) do
      post "/api/v1/club_deals/#{@deal.deal_id}/order", params: { used_points: 500000, cash_amount: 13700000 }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["order_id"].start_with?("ord_")
    assert_equal "ORDER_PLACED", json["status"]
    assert_equal 450000, json["remaining_points"]
  end
end
