require "test_helper"

class Api::V1::Home::WelcomesControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/home/welcome returns welcome home response" do
    get "/api/v1/home/welcome"

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "디에이치 방배", json["complex_name"]
    assert_kind_of Array, json["art_docents"]
    assert_equal "더샵 갤러리 '조경과 빛'", json["art_docents"].first["title"]
    assert_equal "https://cdn.aratel.com/audio/docent1.webp", json["art_docents"].first["audio_url"]

    assert_kind_of Array, json["facilities_status"]
    assert_equal "스카이라운지", json["facilities_status"].first["facility_name"]
    assert_equal "NORMAL", json["facilities_status"].first["crowd_level"]

    assert_kind_of Hash, json["smart_home_state"]
    assert_equal "ON", json["smart_home_state"]["lighting"]
    assert_equal 22.5, json["smart_home_state"]["hvac_temperature"]
    assert_equal "AUTO", json["smart_home_state"]["ventilation"]
  end
end
