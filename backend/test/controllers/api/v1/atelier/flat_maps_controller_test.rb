require "test_helper"

class Api::V1::Atelier::FlatMapsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/atelier/flat_maps returns flat_map_url and furniture_catalog" do
    get "/api/v1/atelier/flat_maps"

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "https://storage.aratel.com/3d/dh_bangbae_84a.gltf", json["flat_map_url"]
    assert_kind_of Array, json["furniture_catalog"]
    assert_not_empty json["furniture_catalog"]

    item = json["furniture_catalog"].first
    assert_equal "furn_101", item["id"]
    assert_equal "B&B Italia", item["brand"]
    assert_equal "Camaleonda Sofa", item["name"]
    assert_equal "https://storage.aratel.com/3d/sofa_bb.gltf", item["model_3d_url"]
    assert_equal 18500000, item["price"]
    assert_equal 3, item["stock"]
  end
end
