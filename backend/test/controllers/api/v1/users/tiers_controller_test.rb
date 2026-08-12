require "test_helper"

class Api::V1::Users::TiersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      user_id: "usr_1001",
      name: "홍길동",
      tier: "DIAMOND",
      badges: ["VERIFIED_OWNER", "DIAMOND_BLACK"],
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    )
  end

  test "GET /api/v1/users/me/tier with existing user returns contract response" do
    get "/api/v1/users/me/tier", headers: { "X-User-Id" => "usr_1001" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "usr_1001", json["user_id"]
    assert_equal "DIAMOND", json["tier"]
    assert_equal ["VERIFIED_OWNER", "DIAMOND_BLACK"], json["badges"]
    assert_equal "디에이치 방배", json["complex_name"]
    assert_equal "101동 1502호", json["building_unit"]
    assert_equal true, json["security_profile"]["screen_capture_prevented"]
    assert_equal true, json["security_profile"]["privacy_masked"]
  end

  test "GET /api/v1/users/me/tier with query param user_id" do
    user = User.create!(user_id: "usr_2002", name: "김철수", tier: "GOLD")
    get "/api/v1/users/me/tier", params: { user_id: "usr_2002" }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "usr_2002", json["user_id"]
    assert_equal "GOLD", json["tier"]
  end

  test "GET /api/v1/users/me/tier creates default user if none exists" do
    User.destroy_all

    get "/api/v1/users/me/tier", as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "usr_1001", json["user_id"]
    assert_equal "DIAMOND", json["tier"]
  end
end
