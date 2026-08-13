require "test_helper"

class CurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    post demo_login_path(user_id: @user.id)

    @item = FurnitureCatalog.create!(
      furniture_id: "furn_101",
      brand: "B&B Italia",
      name: "Camaleonda Sofa",
      model_3d_url: "https://storage.aratel.com/3d/sofa_bb.gltf",
      price: 18500000,
      stock: 3
    )
    @deal = ClubDeal.create!(
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
  end

  test "should get curation view with all tabs" do
    get curation_path
    assert_response :success
    assert_select "h1", text: /ARATEL MAISON CURATION/
    assert_select "h2", text: /3D 평면도 공간 규격/
    assert_select "h2", text: /VVIP 클럽 딜 특가 구매/
    assert_select "h2", text: /VIP 컨시어지 뱅킹/
  end

  test "should get curation view when catalog and club deals are empty" do
    FurnitureCatalog.destroy_all
    ClubDeal.destroy_all
    get curation_path(tab: "atelier")
    assert_response :success
    assert_select "h3", text: /Camaleonda Sofa/
  end

  test "should simulate atelier via curation" do
    assert_difference("FurnitureSimulation.count", 1) do
      post simulate_atelier_curation_path, params: { flat_map_id: "flat_84a", furniture_id: "furn_101" }
    end
    assert_response :success
    assert_includes response.body, "sim_"
  end

  test "should order club deal via curation" do
    assert_difference("ClubDealOrder.count", 1) do
      post order_club_deal_curation_path, params: { deal_id: "deal_552", used_points: 500000, cash_amount: 13700000 }
    end
    assert_redirected_to curation_path(tab: "club_deal")
    follow_redirect!
    assert_select ".alert-success", text: /클럽 딜 주문/
  end

  test "should reserve concierge via curation" do
    assert_difference("ConciergeReservation.count", 1) do
      post reserve_concierge_curation_path, params: {
        service_type: "WOORI_TWO_CHAIRS",
        preferred_date: "2026-08-25",
        notes: "자산 관리 상담"
      }
    end
    assert_redirected_to curation_path(tab: "concierge")
    follow_redirect!
    assert_select ".alert-success", text: /VIP 컨시어지 예약/
  end
end
