AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && !AdminUser.exists?(email: 'admin@example.com')

ResidentialComplex.find_or_create_by!(name: "디에이치 방배") do |c|
  c.primary_color = "#2563eb"
  c.secondary_color = "#1e293b"
  c.accent_color = "#d4af37"
  c.banner_title = "디에이치 방배 하이엔드 갤러리 웰컴 홈"
  c.description = "방배의 명품 랜드마크 입주민을 위한 프리미엄 아뜰리에 및 스마트 웰컴 서비스"
end

ResidentialComplex.find_or_create_by!(name: "한남 더힐") do |c|
  c.primary_color = "#0f172a"
  c.secondary_color = "#065f46"
  c.accent_color = "#fbbf24"
  c.banner_title = "한남 더힐 VVIP 펜트하우스 프라이빗 갤러리"
  c.description = "대한민국 최상위 VVIP를 위한 프라이빗 컨시어지 및 전용 큐레이션 서비서"
end

User.find_or_create_by!(name: "홍길동") do |u|
  u.phone_number = "01012345678"
  u.birth_date = "19800101"
  u.tier = "GOLD"
  u.complex_name = "디에이치 방배"
  u.building_number = "101동"
  u.unit_number = "1502호"
  u.badges_list = ["VERIFIED_OWNER", "RESIDENT"]
end

User.find_or_create_by!(name: "이서진") do |u|
  u.phone_number = "01099998888"
  u.birth_date = "19750505"
  u.tier = "DIAMOND_BLACK"
  u.complex_name = "한남 더힐"
  u.building_number = "102동"
  u.unit_number = "801호"
  u.badges_list = ["VERIFIED_OWNER", "RESIDENT", "DIAMOND_BLACK"]
end