require "test_helper"

class ConciergesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    post demo_login_path(user_id: @user.id)
  end

  test "should get show view" do
    get concierge_path
    assert_response :success
    assert_select "h1", text: /VIP 컨시어지/
  end

  test "should create reservation via web form" do
    assert_difference("ConciergeReservation.count", 1) do
      post concierge_reservations_path, params: {
        concierge_reservation: {
          service_type: "WOORI_TWO_CHAIRS",
          preferred_date: "2026-08-20",
          notes: "자산 증여 상담"
        }
      }
    end
    assert_redirected_to concierge_path
    follow_redirect!
    assert_select "div", text: /예약이 완료되었습니다/
  end

  test "should create reservation via api" do
    assert_difference("ConciergeReservation.count", 1) do
      post api_v1_concierge_reservations_path, params: {
        service_type: "WOORI_TWO_CHAIRS",
        preferred_date: "2026-08-20",
        notes: "자산 증여 및 외환 법률 상담 희망"
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["reservation_id"].start_with?("res_")
    assert_equal "WOORI_TWO_CHAIRS", json["service_type"]
    assert_equal "CONFIRMED", json["status"]
    assert_includes json["assigned_consultant"], "TWO CHAIRS"
  end
end
