require "test_helper"

class InsightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    post demo_login_path(user_id: @user.id)
    @tx1 = RealEstateTransaction.create!(complex_name: "디에이치 방배", floor: 15, price: 2850000000, deal_date: "2026-07-15")
    @tx2 = RealEstateTransaction.create!(complex_name: "디에이치 방배", floor: 3, price: 2510000000, deal_date: "2026-07-10")
  end

  test "should get show view with scatter plot, urgent deals, and wealth investment proposals" do
    get insight_path
    assert_response :success
    assert_select "h1", text: /자산 증식 인사이트/
    assert_select "h2", text: /급매물 & 시세 이하/
    assert_select "h2", text: /부동산 트렌드 & 하이엔드 절세/
    assert_select "h2", text: /VVIP 자산 증식 & 부동산 프라이빗 투자 제안/
  end

  test "should get show view when no transactions exist" do
    RealEstateTransaction.destroy_all
    get insight_path
    assert_response :success
    assert_select "h1", text: /자산 증식 인사이트/
  end

  test "should return api transactions and wealth expansion intelligence" do
    get api_v1_insights_transactions_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "디에이치 방배", json["complex_name"]
    assert_kind_of Array, json["transactions"]
    assert_equal 15, json["transactions"].first["floor"]
    assert_equal "LOW", json["supply_gas_index"]["risk_level"]
    assert_equal 450, json["supply_gas_index"]["upcoming_supply_units"]
    assert_kind_of Array, json["urgent_deals"]
    assert_kind_of Array, json["wealth_news"]
    assert_kind_of Array, json["investment_proposals"]
  end

  test "should return api transactions when empty" do
    RealEstateTransaction.destroy_all
    get api_v1_insights_transactions_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "디에이치 방배", json["complex_name"]
    assert_equal 15, json["transactions"].first["floor"]
  end
end
