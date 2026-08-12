require "test_helper"

class HomeWelcomeTest < ActiveSupport::TestCase
  test "data returns complete structure for welcome home" do
    welcome = HomeWelcome.new(complex_name: "디에이치 방배")
    data = welcome.as_json

    assert_equal "디에이치 방배", data[:complex_name]
    assert_kind_of Array, data[:art_docents]
    assert_not_empty data[:art_docents]
    assert_equal "더샵 갤러리 '조경과 빛'", data[:art_docents].first[:title]

    assert_kind_of Array, data[:facilities_status]
    assert_equal 3, data[:facilities_status].length
    assert_equal "스카이라운지", data[:facilities_status].first[:facility_name]

    assert_kind_of Hash, data[:smart_home_state]
    assert_equal "ON", data[:smart_home_state][:lighting]
    assert_equal 22.5, data[:smart_home_state][:hvac_temperature]
    assert_equal "AUTO", data[:smart_home_state][:ventilation]
  end

  test "default complex_name is fallback if blank" do
    welcome = HomeWelcome.new(complex_name: nil)
    assert_equal "디에이치 방배", welcome.complex_name
  end
end
