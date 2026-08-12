ActiveAdmin.register ClubDeal do
  menu priority: 5, label: "🏷️ 프라이빗 클럽 딜 관리"

  permit_params :brand, :item_name, :original_price, :deal_price, :point_discount_limit, :min_participants, :current_participants, :status

  index title: "수입 명품 클럽 딜 목록" do
    selectable_column
    id_column
    column "브랜드", :brand
    column "상품명", :item_name
    column "정가" do |deal|
      number_to_currency(deal.original_price, unit: "원", format: "%n%u", precision: 0)
    end
    column "클럽딜가" do |deal|
      number_to_currency(deal.deal_price, unit: "원", format: "%n%u", precision: 0)
    end
    column "참여 인원" do |deal|
      "#{deal.current_participants} / #{deal.min_participants}명"
    end
    column "상태", :status do |deal|
      status_tag deal.status
    end
    actions
  end

  filter :brand
  filter :status, as: :select, collection: ["OPEN", "CLOSED", "FULFILLED"]
end
