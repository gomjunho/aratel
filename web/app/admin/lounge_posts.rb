ActiveAdmin.register LoungePost do
  menu priority: 4, label: "💬 익명 라운지 모니터링"

  permit_params :clean_signal_verified, :is_diamond_weighted, :trust_score, :anonymous_nickname

  index title: "익명 라운지 게시글 관리" do
    selectable_column
    id_column
    column "익명 닉네임", :anonymous_nickname
    column "단지명", :complex_name
    column "제목", :title
    column "Trust Score", :trust_score
    column "Clean Signal 검증", :clean_signal_verified do |post|
      status_tag post.clean_signal_verified? ? "CLEAN" : "SUSPICIOUS"
    end
    column "Diamond 상단 가중치", :is_diamond_weighted
    column "작성일", :created_at
    actions
  end

  filter :complex_name
  filter :clean_signal_verified
  filter :is_diamond_weighted
  filter :trust_score
end
