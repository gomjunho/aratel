require "test_helper"

class ConciergeReservationTest < ActiveSupport::TestCase
  test "valid reservation assigns consultant and defaults" do
    res = ConciergeReservation.new(
      service_type: "WOORI_TWO_CHAIRS",
      preferred_date: "2026-08-20",
      notes: "자산 증여 및 외환 법률 상담 희망"
    )

    assert res.valid?
    assert_not_nil res.reservation_id
    assert res.reservation_id.start_with?("res_")
    assert_equal "CONFIRMED", res.status
    assert_equal "우리은행 TWO CHAIRS 수석 자산관리사", res.assigned_consultant
  end

  test "assigns correct consultant for different service types" do
    pest = ConciergeReservation.new(service_type: "LUXURY_PEST_CONTROL")
    pest.valid?
    assert_equal "세스코 VVIP 프리미엄 케어팀", pest.assigned_consultant

    health = ConciergeReservation.new(service_type: "HEALTH_CHECKUP")
    health.valid?
    assert_equal "서울대병원 VIP 헬스케어 전담팀", health.assigned_consultant

    art = ConciergeReservation.new(service_type: "ART_SUBSCRIPTION")
    art.valid?
    assert_equal "국립현대미술관 수석 큐레이터", art.assigned_consultant

    other = ConciergeReservation.new(service_type: "CUSTOM_SERVICE")
    other.valid?
    assert_equal "VIP 전담 컨시어지", other.assigned_consultant
  end

  test "invalid without service_type" do
    res = ConciergeReservation.new(service_type: "")
    assert_not res.valid?
    assert_includes res.errors[:service_type], "can't be blank"
  end

  test "as_created_json formats json output" do
    res = ConciergeReservation.new(
      reservation_id: "res_7710",
      service_type: "WOORI_TWO_CHAIRS",
      status: "CONFIRMED",
      assigned_consultant: "우리은행 TWO CHAIRS 수석 자산관리사"
    )
    json = res.as_created_json

    assert_equal "res_7710", json[:reservation_id]
    assert_equal "WOORI_TWO_CHAIRS", json[:service_type]
    assert_equal "CONFIRMED", json[:status]
    assert_equal "우리은행 TWO CHAIRS 수석 자산관리사", json[:assigned_consultant]
  end
end
