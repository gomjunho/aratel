class CurationsController < ApplicationController
  def show
    @active_tab = params[:tab].presence || "all"

    @flat_map_url = "https://storage.aratel.com/3d/dh_bangbae_84a.gltf"
    @space_measurements = [
      { name: "거실 (Living Room)", dimensions: "4.8m × 3.6m", max_furniture_size: "3.2m 이하" },
      { name: "다이닝 룸 (Dining Room)", dimensions: "3.5m × 3.0m", max_furniture_size: "2.4m 이하" },
      { name: "마스터 룸 (Master Bedroom)", dimensions: "3.9m × 3.5m", max_furniture_size: "2.8m 이하" }
    ]

    @furniture_catalog = FurnitureCatalog.all
    if @furniture_catalog.empty?
      @furniture_catalog = [
        FurnitureCatalog.create!(
          furniture_id: "furn_101",
          brand: "B&B Italia",
          name: "Camaleonda Sofa",
          model_3d_url: "https://storage.aratel.com/3d/sofa_bb.gltf",
          price: 18500000,
          stock: 3
        )
      ]
    end

    @club_deals = ClubDeal.all
    if @club_deals.empty?
      @club_deals = [
        ClubDeal.create!(
          deal_id: "deal_552",
          brand: "B&B Italia",
          item_name: "Camaleonda Sofa VVIP Club Deal",
          original_price: 18500000,
          deal_price: 14200000,
          point_discount_limit: 1000000,
          min_participants: 5,
          current_participants: 3,
          status: "OPEN"
        )
      ]
    end

    @reservations = ConciergeReservation.where(user: current_user).order(created_at: :desc)
    @concierge_services = [
      { id: "WOORI_TWO_CHAIRS", name: "우리은행 TWO CHAIRS VVIP 자산 증여 컨설팅", desc: "PB 전담 수석 자산관리사 1:1 방문 맞춤 컨설팅" },
      { id: "HOME_HYGIENE", name: "세스코 VVIP 홈 하이보안 위생 케어", desc: "첨단 바이러스 케어 및 실내 공기질 토탈 프리미엄 케어" },
      { id: "HEALTH_CHECKUP", name: "서울대병원 VIP 패스트트랙 프리미엄 정밀검진", desc: "입주민 전용 수석 의료진 1:1 매칭 종합 검진" }
    ]
  end

  def simulate_atelier
    show
    flat_map_id = params[:flat_map_id] || "flat_84a"
    furniture_id = params[:furniture_id] || "furn_101"

    sim_id = "sim_#{SecureRandom.random_number(1000..9999)}"
    @simulation = FurnitureSimulation.create!(
      simulation_id: sim_id,
      flat_map_id: flat_map_id,
      placed_items: [{ furniture_id: furniture_id, position: [1.2, 0.0, 3.4], rotation: [0, 90, 0] }].to_json,
      club_deal_triggered: true,
      club_deal_id: "deal_552",
      user: current_user
    )
    @simulation_result = {
      simulation_id: @simulation.simulation_id,
      club_deal_triggered: @simulation.club_deal_triggered,
      club_deal_id: @simulation.club_deal_id
    }
    render :show
  end

  def order_club_deal
    deal_id = params[:deal_id] || "deal_552"
    used_points = params[:used_points].to_i
    cash_amount = params[:cash_amount].to_i
    order_id = "ord_#{SecureRandom.random_number(1000..9999)}"

    order = ClubDealOrder.create!(
      order_id: order_id,
      club_deal_id: deal_id,
      user: current_user,
      used_points: used_points,
      cash_amount: cash_amount,
      status: "ORDER_PLACED",
      remaining_points: 450000
    )

    redirect_to curation_path(tab: "club_deal"), notice: "VVIP 큐레이션 클럽 딜 주문(#{order.order_id})이 성공적으로 접수되었습니다!"
  end

  def reserve_concierge
    service_type = params[:service_type].presence || "WOORI_TWO_CHAIRS"
    preferred_date = params[:preferred_date].presence || Date.today.to_s
    notes = params[:notes].presence || "VVIP 큐레이션 센터 접수"

    reservation_id = "res_#{SecureRandom.random_number(1000..9999)}"
    ConciergeReservation.create!(
      reservation_id: reservation_id,
      service_type: service_type,
      preferred_date: preferred_date,
      notes: notes,
      status: "CONFIRMED",
      assigned_consultant: "TWO CHAIRS 수석 PB 팀장",
      user: current_user
    )

    redirect_to curation_path(tab: "concierge"), notice: "VIP 컨시어지 예약(#{reservation_id})이 완료되었습니다."
  end
end
