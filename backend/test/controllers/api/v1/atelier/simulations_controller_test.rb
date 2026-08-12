require "test_helper"

class Api::V1::Atelier::SimulationsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/atelier/simulations with valid params creates simulation" do
    post "/api/v1/atelier/simulations", params: {
      flat_map_id: "flat_84a",
      placed_items: [
        { furniture_id: "furn_101", position: [1.2, 0.0, 3.4], rotation: [0, 90, 0] }
      ]
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)

    assert json["simulation_id"].start_with?("sim_")
    assert_equal true, json["club_deal_triggered"]
    assert_equal "deal_552", json["club_deal_id"]
  end

  test "POST /api/v1/atelier/simulations with invalid params returns 422" do
    post "/api/v1/atelier/simulations", params: {
      flat_map_id: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)

    assert_equal "error", json["status"]
    assert_not_nil json["errors"]
  end
end
