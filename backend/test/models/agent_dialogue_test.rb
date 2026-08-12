require "test_helper"

class AgentDialogueTest < ActiveSupport::TestCase
  test "dialogue handles breakfast reservation request" do
    dialogue = AgentDialogue.new(message: "라운지 조식 2명 예약해줘")
    data = dialogue.process

    assert_equal "네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.", data[:reply]
    assert_equal "RESERVE_BREAKFAST", data[:action_executed]
    assert_equal "스카이라운지", data.dig(:reservation_details, :facility)
    assert_equal 2, data.dig(:reservation_details, :party_size)
    assert_equal "CONFIRMED", data.dig(:reservation_details, :status)
  end

  test "dialogue handles custom party size for breakfast reservation" do
    dialogue = AgentDialogue.new(message: "스카이라운지 조식 4명 예약 부탁해")
    data = dialogue.process

    assert_equal "네, 디에이치 방배 스카이라운지 조식 4명 예약이 완료되었습니다.", data[:reply]
    assert_equal 4, data.dig(:reservation_details, :party_size)
  end

  test "dialogue handles general query message" do
    dialogue = AgentDialogue.new(message: "안녕하세요 피트니스 센타 혼잡도 알려줘")
    data = dialogue.process

    assert_equal "안녕하세요! 단지 안내 및 스마트 홈 제어, 부대시설 예약을 도와드리는 ARATEL AI 에이전트입니다.", data[:reply]
    assert_equal "NONE", data[:action_executed]
    assert_nil data[:reservation_details]
  end

  test "dialogue handles blank message" do
    dialogue = AgentDialogue.new(message: "")
    data = dialogue.process

    assert_equal "요청 메시지를 입력해 주세요.", data[:reply]
    assert_equal "NONE", data[:action_executed]
    assert_nil data[:reservation_details]
  end
end
