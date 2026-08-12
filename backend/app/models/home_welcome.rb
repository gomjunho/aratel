class HomeWelcome
  attr_reader :complex_name

  DEFAULT_COMPLEX = "디에이치 방배"

  def initialize(complex_name: nil)
    @complex_name = complex_name.presence || DEFAULT_COMPLEX
  end

  def art_docents
    [
      {
        title: "더샵 갤러리 '조경과 빛'",
        audio_url: "https://storage.aratel.com/audio/docent1.mp3",
        description: "단지 중앙 정원에 위치한 현대 미술 조형물에 대한 설명입니다."
      }
    ]
  end

  def facilities_status
    [
      { facility_name: "스카이라운지", crowd_level: "NORMAL", active_reservations: 12 },
      { facility_name: "피트니스 센타", crowd_level: "CROWDED", active_reservations: 45 },
      { facility_name: "사우나", crowd_level: "SMOOTH", active_reservations: 8 }
    ]
  end

  def smart_home_state
    {
      lighting: "ON",
      hvac_temperature: 22.5,
      ventilation: "AUTO"
    }
  end

  def as_json(_options = nil)
    {
      complex_name: complex_name,
      art_docents: art_docents,
      facilities_status: facilities_status,
      smart_home_state: smart_home_state
    }
  end
end
