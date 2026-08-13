require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101", complex_name: "디에이치 방배", building_number: "101동", unit_number: "1502호", tier: "GOLD")
  end

  test "should get unauthenticated guest show view" do
    get home_path
    assert_response :success
    assert_includes response.body, "게스트 미인증 상태"
    assert_includes response.body, "제한적 게스트 화면"
  end

  test "should get authenticated show view" do
    post demo_login_path(user_id: @user.id)
    get home_path
    assert_response :success
    assert_includes response.body, "디에이치 방배"
    assert_select "div", text: /조경과 빛/
    assert_select "div", text: /스카이라운지/
  end

  test "should handle agent dialogue via web when authenticated" do
    post demo_login_path(user_id: @user.id)
    post agent_dialogue_home_path, params: { message: "라운지 조식 2명 예약해줘" }
    assert_response :success
    assert_includes response.body, "스카이라운지 조식 2명 예약이 완료되었습니다"
  end

  test "should return api welcome data" do
    get api_v1_home_welcome_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "디에이치 방배", json["complex_name"]
    assert_kind_of Array, json["art_docents"]
    assert_kind_of Array, json["facilities_status"]
    assert_equal "ON", json["smart_home_state"]["lighting"]
  end

  test "should return api agent dialogue" do
    post api_v1_ai_agent_dialogue_path, params: { message: "라운지 조식 2명 예약해줘" }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "RESERVE_BREAKFAST", json["action_executed"]
    assert_equal "스카이라운지", json["reservation_details"]["facility"]
    assert_equal 2, json["reservation_details"]["party_size"]
  end
end
