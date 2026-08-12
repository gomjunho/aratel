require "test_helper"

class AtelierSimulationTest < ActiveSupport::TestCase
  test "valid atelier simulation sets simulation_id and defaults" do
    sim = AtelierSimulation.new(
      flat_map_id: "flat_84a",
      placed_items: [{ furniture_id: "furn_101", position: [1.2, 0.0, 3.4], rotation: [0, 90, 0] }].to_json
    )

    assert sim.valid?
    assert_not_nil sim.simulation_id
    assert sim.simulation_id.start_with?("sim_")
    assert_equal true, sim.club_deal_triggered
    assert_equal "deal_552", sim.club_deal_id
  end

  test "invalid without flat_map_id" do
    sim = AtelierSimulation.new(flat_map_id: "")
    assert_not sim.valid?
    assert_includes sim.errors[:flat_map_id], "can't be blank"
  end

  test "as_created_json returns contract payload" do
    sim = AtelierSimulation.new(simulation_id: "sim_8812", flat_map_id: "flat_84a")
    json = sim.as_created_json

    assert_equal "sim_8812", json[:simulation_id]
    assert_equal true, json[:club_deal_triggered]
    assert_equal "deal_552", json[:club_deal_id]
  end
end
