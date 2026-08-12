ActiveAdmin.register ConciergeReservation do
  menu priority: 6, label: "🛎️ VIP 컨시어지 예약 관리"

  permit_params :service_type, :preferred_date, :notes, :status, :assigned_consultant

  index title: "VIP 컨시어지 서비스 예약 목록" do
    selectable_column
    id_column
    column "신청 회원" do |res|
      link_to res.user.name, admin_user_path(res.user)
    end
    column "서비스 유형", :service_type do |res|
      status_tag res.service_type
    end
    column "희망일자", :preferred_date
    column "담당 컨설턴트", :assigned_consultant
    column "예약 상태", :status do |res|
      status_tag res.status
    end
    actions
  end

  filter :service_type, as: :select, collection: ["WOORI_TWO_CHAIRS", "LUXURY_PEST_CONTROL", "HEALTH_CHECKUP", "ART_SUBSCRIPTION"]
  filter :status, as: :select, collection: ["CONFIRMED", "PENDING", "CANCELLED"]
end
