class AteliersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_flat_maps, :api_create_simulation]

  def show
    @flat_map_url = "https://storage.aratel.com/3d/dh_bangbae_84a.gltf"
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
  end

  def simulate
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

  def api_flat_maps
    catalog = FurnitureCatalog.all
    if catalog.empty?
      catalog = [
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

    render json: {
      flat_map_url: "https://storage.aratel.com/3d/dh_bangbae_84a.gltf",
      furniture_catalog: catalog.map do |c|
        {
          id: c.furniture_id,
          brand: c.brand,
          name: c.name,
          model_3d_url: c.model_3d_url,
          price: c.price,
          stock: c.stock
        }
      end
    }, status: :ok
  end

  def api_create_simulation
    flat_map_id = params[:flat_map_id]
    placed_items = params[:placed_items]

    sim_id = "sim_#{SecureRandom.random_number(1000..9999)}"
    sim = FurnitureSimulation.create!(
      simulation_id: sim_id,
      flat_map_id: flat_map_id,
      placed_items: placed_items.to_json,
      club_deal_triggered: true,
      club_deal_id: "deal_552",
      user: current_user
    )

    render json: {
      simulation_id: sim.simulation_id,
      club_deal_triggered: sim.club_deal_triggered,
      club_deal_id: sim.club_deal_id
    }, status: :created
  end
end
