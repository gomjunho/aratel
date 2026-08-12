require "test_helper"

class EpicsModelsTest < ActiveSupport::TestCase
  test "LoungePost validation and creation" do
    post = LoungePost.create!(
      post_id: "post_7001",
      anonymous_nickname: "은밀한 자산가 42",
      title: "테스트 제목",
      content_encrypted: "EncryptedBodyPayload..."
    )
    assert_equal "post_7001", post.post_id
    assert post.valid?
  end

  test "FurnitureCatalog validation and creation" do
    item = FurnitureCatalog.create!(
      furniture_id: "furn_101",
      brand: "B&B Italia",
      name: "Camaleonda Sofa",
      model_3d_url: "https://storage.aratel.com/3d/sofa_bb.gltf",
      price: 18500000,
      stock: 3
    )
    assert_equal "furn_101", item.furniture_id
  end

  test "FurnitureSimulation validation and creation" do
    sim = FurnitureSimulation.create!(
      simulation_id: "sim_8812",
      flat_map_id: "flat_84a",
      placed_items: '[{"furniture_id":"furn_101"}]',
      club_deal_triggered: true,
      club_deal_id: "deal_552"
    )
    assert_equal "sim_8812", sim.simulation_id
  end

  test "ClubDeal validation and creation" do
    deal = ClubDeal.create!(
      deal_id: "deal_552",
      brand: "B&B Italia",
      item_name: "Camaleonda Sofa VVIP Club Deal",
      original_price: 18500000,
      deal_price: 14200000,
      point_discount_limit: 1000000,
      min_participants: 5,
      current_participants: 3
    )
    assert_equal "deal_552", deal.deal_id
  end

  test "ClubDealOrder validation and creation" do
    order = ClubDealOrder.create!(
      order_id: "ord_9901",
      club_deal_id: "deal_552",
      used_points: 500000,
      cash_amount: 13700000,
      remaining_points: 450000
    )
    assert_equal "ord_9901", order.order_id
  end

  test "ConciergeReservation validation and creation" do
    res = ConciergeReservation.create!(
      reservation_id: "res_7710",
      service_type: "WOORI_TWO_CHAIRS",
      preferred_date: "2026-08-20",
      notes: "자산 증여 상담"
    )
    assert_equal "res_7710", res.reservation_id
  end

  test "RealEstateTransaction creation" do
    tx = RealEstateTransaction.create!(
      complex_name: "디에이치 방배",
      floor: 15,
      price: 2850000000,
      deal_date: "2026-07-15"
    )
    assert_equal 15, tx.floor
  end

  test "ArtDocent and FacilityStatus creation" do
    docent = ArtDocent.create!(title: "조경과 빛", audio_url: "http://example.com/audio.mp3", description: "설명")
    facility = FacilityStatus.create!(facility_name: "스카이라운지", crowd_level: "NORMAL", active_reservations: 12)
    assert_equal "조경과 빛", docent.title
    assert_equal "스카이라운지", facility.facility_name
  end
end
