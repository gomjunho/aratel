require "test_helper"

class Api::V1::Ai::AgentDialoguesControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/ai/agent_dialogue with reservation message" do
    post "/api/v1/ai/agent_dialogue", params: {
      message: "라운지 조식 2명 예약해줘"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.", json["reply"]
    assert_equal "RESERVE_BREAKFAST", json["action_executed"]
    assert_equal "스카이라운지", json["reservation_details"]["facility"]
    assert_equal 2, json["reservation_details"]["party_size"]
    assert_equal "CONFIRMED", json["reservation_details"]["status"]
  end

  test "POST /api/v1/ai/agent_dialogue with general message" do
    post "/api/v1/ai/agent_dialogue", params: {
      message: "안녕하세요"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "NONE", json["action_executed"]
    assert_nil json["reservation_details"]
  end

  test "POST /api/v1/ai/agent_dialogue with empty message returns 422" do
    post "/api/v1/ai/agent_dialogue", params: {
      message: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "요청 메시지를 입력해 주세요.", json["reply"]
  end
end
