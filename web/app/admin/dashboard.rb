ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: "🏛️ ARATEL VVIP 어드민 거버넌스 센터" do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        h2 "ARATEL 총괄 운영 및 VVIP 심사 센터에 오신 것을 환영합니다."
      end
    end

    columns do
      column do
        panel "📊 VVIP 서비스 핵심 통계" do
          ul do
            li "전체 회원 수: #{User.count}명"
            li "심사 대기 증빙 건수: #{TierEvidence.where(status: 'UNDER_REVIEW').count}건"
            li "대리인 승인 대기 건수: #{DelegatedAccessRequest.where(status: 'PENDING_OWNER_APPROVAL').count}건"
            li "진행 중인 프라이빗 클럽 딜: #{ClubDeal.where(status: 'OPEN').count}개"
            li "확정된 VIP 컨시어지 예약: #{ConciergeReservation.where(status: 'CONFIRMED').count}건"
          end
        end
      end

      column do
        panel "🚨 긴급 서류 심사 대기열 (최근 5건)" do
          table_for TierEvidence.where(status: "UNDER_REVIEW").order(created_at: :desc).limit(5) do
            column("회원") { |e| link_to e.user.name, admin_user_path(e.user) }
            column("목표 등급") { |e| status_tag e.target_tier }
            column("서류 보기") { |e| link_to "서류 🔗", e.document_url, target: "_blank" }
            column("심사") { |e| link_to "상세 심사 ➔", admin_tier_evidence_path(e) }
          end
        end
      end
    end
  end
end
