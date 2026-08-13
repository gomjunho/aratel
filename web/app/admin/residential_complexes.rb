ActiveAdmin.register ResidentialComplex do
  menu priority: 1, label: "🏢 단지별 테마 설정"

  permit_params :name, :primary_color, :secondary_color, :accent_color, :banner_title, :description

  index title: "🏢 단지별 테마 및 브랜드 관리" do
    selectable_column
    id_column
    column "단지명", :name
    column "주요 테마 색상 (Primary)" do |complex|
      status_tag complex.primary_color, style: "background-color: #{complex.primary_color}; color: #fff; padding: 4px 10px; font-weight: bold;"
    end
    column "보조 테마 색상 (Secondary)" do |complex|
      status_tag complex.secondary_color, style: "background-color: #{complex.secondary_color}; color: #fff; padding: 4px 10px; font-weight: bold;"
    end
    column "포인트 색상 (Accent)" do |complex|
      status_tag complex.accent_color, style: "background-color: #{complex.accent_color}; color: #000; padding: 4px 10px; font-weight: bold;"
    end
    column "배너 타이틀", :banner_title
    column "등록일", :created_at
    actions
  end

  form title: "🏢 단지별 테마 색상 수정" do |f|
    f.inputs "단지 테마 색상 및 가이드" do
      f.input :name, label: "단지명"
      f.input :primary_color, label: "주요 테마 색상 (Primary Color Hex)"
      f.input :secondary_color, label: "보조 테마 색상 (Secondary Color Hex)"
      f.input :accent_color, label: "포인트 색상 (Accent Color Hex)"
      f.input :banner_title, label: "웰컴 배너 타이틀"
      f.input :description, label: "단지 설명 및 브랜딩 문구"
    end
    f.actions
  end

  show title: ->(complex) { "🏢 #{complex.name} 테마 상세" } do
    attributes_table do
      row "ID", &:id
      row "단지명", &:name
      row "주요 테마 색상 (Primary)" do |complex|
        span complex.primary_color, style: "background-color: #{complex.primary_color}; color: #fff; padding: 6px 12px; border-radius: 4px; font-weight: bold;"
      end
      row "보조 테마 색상 (Secondary)" do |complex|
        span complex.secondary_color, style: "background-color: #{complex.secondary_color}; color: #fff; padding: 6px 12px; border-radius: 4px; font-weight: bold;"
      end
      row "포인트 색상 (Accent)" do |complex|
        span complex.accent_color, style: "background-color: #{complex.accent_color}; color: #000; padding: 6px 12px; border-radius: 4px; font-weight: bold;"
      end
      row "배너 타이틀", &:banner_title
      row "단지 설명", &:description
      row "생성일", &:created_at
      row "수정일", &:updated_at
    end
  end
end
