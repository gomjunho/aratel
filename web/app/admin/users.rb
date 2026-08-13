ActiveAdmin.register User do
  menu priority: 1, label: "👑 VVIP 회원 관리"

  permit_params :name, :phone_number, :tier, :complex_name, :building_number, :unit_number, badges: []

  index title: "VVIP 회원 목록" do
    selectable_column
    id_column
    column "이름" do |user|
      user.masked_name
    end
    column "전화번호" do |user|
      user.masked_phone
    end
    column "단지명", :complex_name
    column "동/호수" do |user|
      user.masked_unit
    end
    column "멤버십 등급", :tier do |user|
      status_tag user.tier, class: "tier-#{user.tier.downcase}"
    end
    column "가입일", :created_at
    actions
  end


  filter :name
  filter :phone_number
  filter :complex_name
  filter :tier, as: :select, collection: ["DIAMOND", "PLATINUM", "GOLD", "BRONZE"]

  form title: "VVIP 회원 정보 수정" do |f|
    f.inputs "회원 정보" do
      f.input :name, label: "이름"
      f.input :phone_number, label: "전화번호"
      f.input :complex_name, label: "단지명"
      f.input :building_number, label: "동"
      f.input :unit_number, label: "호수"
      f.input :tier, as: :select, collection: ["DIAMOND", "PLATINUM", "GOLD", "BRONZE"], label: "멤버십 등급"
    end
    f.actions
  end
end
