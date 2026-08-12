ActiveAdmin.register TierEvidence do
  menu priority: 2, label: "📄 VVIP 자산 증빙 심사"

  permit_params :status, :admin_notes, :target_tier

  member_action :approve, method: :put do
    resource.approve!
    redirect_to admin_tier_evidences_path, notice: "자산 증빙이 승인되었으며 회원의 등급이 #{resource.target_tier}로 변경되었습니다."
  end

  member_action :reject, method: :put do
    resource.reject!
    redirect_to admin_tier_evidences_path, alert: "자산 증빙이 반려되었습니다."
  end

  index title: "VVIP 자산 증빙 심사 대기열" do
    selectable_column
    id_column
    column "제출 회원" do |evidence|
      link_to evidence.user.name, admin_user_path(evidence.user)
    end
    column "증빙 서류 유형", :evidence_type
    column "목표 등급", :target_tier do |evidence|
      status_tag evidence.target_tier
    end
    column "인스타그램", :instagram_handle
    column "추천인 코드", :referral_code
    column "증빙 서류" do |evidence|
      link_to "서류 보기 🔗", evidence.document_url, target: "_blank"
    end
    column "심사 상태", :status do |evidence|
      status_tag evidence.status
    end
    column "제출일", :created_at
    actions defaults: true do |evidence|
      if evidence.status == "UNDER_REVIEW"
        item "승인", approve_admin_tier_evidence_path(evidence), method: :put, class: "member_link approve_link", data: { confirm: "승인하시겠습니까?" }
        item "반려", reject_admin_tier_evidence_path(evidence), method: :put, class: "member_link reject_link", data: { confirm: "반려하시겠습니까?" }
      end
    end
  end

  filter :status, as: :select, collection: ["UNDER_REVIEW", "VERIFIED", "APPROVED", "REJECTED"]
  filter :evidence_type, as: :select, collection: ["INCOME_CERT", "BANK_BALANCE", "REGISTRATION_NOTICE"]
  filter :target_tier, as: :select, collection: ["DIAMOND", "PLATINUM", "GOLD", "BRONZE"]
end
