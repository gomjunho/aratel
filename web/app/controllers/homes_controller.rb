class HomesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_welcome, :api_agent_dialogue]

  def show
    @complex_name = current_user.complex_name.presence || "디에이치 방배"
    @art_docents = ArtDocent.all
    if @art_docents.empty?
      @art_docents = [
        ArtDocent.new(
          title: "더샵 갤러리 '조경과 빛'",
          audio_url: "https://storage.aratel.com/audio/docent1.mp3",
          description: "단지 중앙 정원에 위치한 현대 미술 조형물에 대한 설명입니다."
        )
      ]
    end

    @facilities_status = FacilityStatus.all
    if @facilities_status.empty?
      @facilities_status = [
        FacilityStatus.new(facility_name: "스카이라운지", crowd_level: "NORMAL", active_reservations: 12),
        FacilityStatus.new(facility_name: "피트니스 센타", crowd_level: "CROWDED", active_reservations: 45),
        FacilityStatus.new(facility_name: "사우나", crowd_level: "SMOOTH", active_reservations: 8)
      ]
    end

    @smart_home_state = {
      lighting: "ON",
      hvac_temperature: 22.5,
      ventilation: "AUTO"
    }
  end

  def agent_dialogue
    show
    @message = params[:message]
    @reply = "네, #{@complex_name || '디에이치 방배'} 스카이라운지 조식 2명 예약이 완료되었습니다."
    @action_executed = "RESERVE_BREAKFAST"
    render :show
  end

  def api_welcome
    render json: {
      complex_name: current_user.complex_name.presence || "디에이치 방배",
      art_docents: [
        {
          title: "더샵 갤러리 '조경과 빛'",
          audio_url: "https://storage.aratel.com/audio/docent1.mp3",
          description: "단지 중앙 정원에 위치한 현대 미술 조형물에 대한 설명입니다."
        }
      ],
      facilities_status: [
        { facility_name: "스카이라운지", crowd_level: "NORMAL", active_reservations: 12 },
        { facility_name: "피트니스 센타", crowd_level: "CROWDED", active_reservations: 45 },
        { facility_name: "사우나", crowd_level: "SMOOTH", active_reservations: 8 }
      ],
      smart_home_state: {
        lighting: "ON",
        hvac_temperature: 22.5,
        ventilation: "AUTO"
      }
    }, status: :ok
  end

  def api_agent_dialogue
    render json: {
      reply: "네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.",
      action_executed: "RESERVE_BREAKFAST",
      reservation_details: {
        facility: "스카이라운지",
        party_size: 2,
        status: "CONFIRMED"
      }
    }, status: :ok
  end
end
