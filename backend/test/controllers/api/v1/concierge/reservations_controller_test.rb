require "test_helper"

class Api::V1::Concierge::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/concierge/reservations with valid params creates reservation" do
    post "/api/v1/concierge/reservations", params: {
      service_type: "WOORI_TWO_CHAIRS",
      preferred_date: "2026-08-20",
      notes: "자산 증여 및 외환 법률 상담 희망"
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)

    assert json["reservation_id"].start_with?("res_")
    assert_equal "WOORI_TWO_CHAIRS", json["service_type"]
    assert_equal "CONFIRMED", json["status"]
    assert_equal "우리은행 TWO CHAIRS 수석 자산관리사", json["assigned_consultant"]
  end

  test "POST /api/v1/concierge/reservations with missing service_type returns 422" do
    post "/api/v1/concierge/reservations", params: {
      service_type: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)

    assert_equal "error", json["status"]
    assert_not_nil json["errors"]
  end
end
