require "test_helper"

class AteliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    @item = FurnitureCatalog.create!(
      furniture_id: "furn_101",
      brand: "B&B Italia",
      name: "Camaleonda Sofa",
      model_3d_url: "https://storage.aratel.com/3d/sofa_bb.gltf",
      price: 18500000,
      stock: 3
    )
  end

  test "should get atelier 3D simulation view" do
    get atelier_path
    assert_response :success
    assert_select "h1", text: /AI 아뜰리에 3D 시뮬레이션/
    assert_select "div", text: /B&B Italia/
    assert_select "div", text: /Camaleonda Sofa/
  end

  test "should get atelier show view when catalog is empty" do
    FurnitureCatalog.destroy_all
    get atelier_path
    assert_response :success
    assert_select "div", text: /Camaleonda Sofa/
  end

  test "should create simulation via web" do
    assert_difference("FurnitureSimulation.count", 1) do
      post simulate_atelier_path, params: { flat_map_id: "flat_84a", furniture_id: "furn_101" }
    end
    assert_response :success
    assert_includes response.body, "sim_"
    assert_includes response.body, "deal_552"
  end

  test "should return api flat maps and catalog" do
    get api_v1_atelier_flat_maps_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "https://storage.aratel.com/3d/dh_bangbae_84a.gltf", json["flat_map_url"]
    assert_kind_of Array, json["furniture_catalog"]
    assert_equal "furn_101", json["furniture_catalog"].first["id"]
  end

  test "should return api flat maps when catalog is empty" do
    FurnitureCatalog.destroy_all
    get api_v1_atelier_flat_maps_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "furn_101", json["furniture_catalog"].first["id"]
  end

  test "should create simulation via api" do
    assert_difference("FurnitureSimulation.count", 1) do
      post api_v1_atelier_simulations_path, params: {
        flat_map_id: "flat_84a",
        placed_items: [{ furniture_id: "furn_101", position: [1.2, 0.0, 3.4], rotation: [0, 90, 0] }]
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["simulation_id"].start_with?("sim_")
    assert_equal true, json["club_deal_triggered"]
    assert_equal "deal_552", json["club_deal_id"]
  end
end
