ActiveAdmin.register DelegatedAccessRequest do
  menu priority: 3, label: "👥 대리인/가족 위임 심사"

  permit_params :status, :relationship

  member_action :approve, method: :put do
    resource.update!(status: "APPROVED")
    resource.user.add_badge("RESIDENT")
    resource.user.save!
    redirect_to admin_delegated_access_requests_path, notice: "위임 신청이 승인되어 Resident 뱃지가 부여되었습니다."
  end

  member_action :reject, method: :put do
    resource.update!(status: "REJECTED")
    redirect_to admin_delegated_access_requests_path, alert: "위임 신청이 반려되었습니다."
  end

  index title: "대리인 및 가족 위임 신청 목록" do
    selectable_column
    id_column
    column "신청 유저" do |del|
      link_to del.user.masked_name, admin_user_path(del.user)
    end

    column "위임 관계", :relationship
    column "증명서" do |del|
      link_to "증명서 보기 🔗", del.document_url, target: "_blank"
    end
    column "상태", :status do |del|
      status_tag del.status
    end
    column "신청일", :created_at
    actions defaults: true do |del|
      if del.status == "PENDING_OWNER_APPROVAL"
        item "승인", approve_admin_delegated_access_request_path(del), method: :put, class: "member_link approve_link"
        item "반려", reject_admin_delegated_access_request_path(del), method: :put, class: "member_link reject_link"
      end
    end
  end

  filter :status, as: :select, collection: ["PENDING_OWNER_APPROVAL", "APPROVED", "REJECTED"]
  filter :relationship, as: :select, collection: ["FAMILY", "MANAGER"]
end
