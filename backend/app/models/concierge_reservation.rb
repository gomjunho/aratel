class ConciergeReservation < ApplicationRecord
  validates :service_type, presence: true
  validates :reservation_id, presence: true, uniqueness: true

  before_validation :set_defaults

  CONSULTANTS = {
    "WOORI_TWO_CHAIRS" => "우리은행 TWO CHAIRS 수석 자산관리사",
    "LUXURY_PEST_CONTROL" => "세스코 VVIP 프리미엄 케어팀",
    "HEALTH_CHECKUP" => "서울대병원 VIP 헬스케어 전담팀",
    "ART_SUBSCRIPTION" => "국립현대미술관 수석 큐레이터"
  }.freeze

  def as_created_json
    {
      reservation_id: reservation_id,
      service_type: service_type,
      status: status,
      assigned_consultant: assigned_consultant
    }
  end

  private

  def set_defaults
    self.reservation_id ||= "res_#{rand(7000..9999)}"
    self.status ||= "CONFIRMED"
    self.assigned_consultant ||= CONSULTANTS[service_type] || "VIP 전담 컨시어지"
  end
end
