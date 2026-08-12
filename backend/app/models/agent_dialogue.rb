class AgentDialogue
  attr_reader :message

  def initialize(message:)
    @message = message.to_s.strip
  end

  def process
    if message.blank?
      {
        reply: "요청 메시지를 입력해 주세요.",
        action_executed: "NONE",
        reservation_details: nil
      }
    elsif message.include?("조식") || message.include?("예약")
      party_size = parse_party_size
      {
        reply: "네, 디에이치 방배 스카이라운지 조식 #{party_size}명 예약이 완료되었습니다.",
        action_executed: "RESERVE_BREAKFAST",
        reservation_details: {
          facility: "스카이라운지",
          party_size: party_size,
          status: "CONFIRMED"
        }
      }
    else
      {
        reply: "안녕하세요! 단지 안내 및 스마트 홈 제어, 부대시설 예약을 도와드리는 ARATEL AI 에이전트입니다.",
        action_executed: "NONE",
        reservation_details: nil
      }
    end
  end

  private

  def parse_party_size
    match = message.match(/(\d+)명/)
    match ? match[1].to_i : 2
  end
end
