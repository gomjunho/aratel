class AtelierCatalog
  def self.fetch_flat_maps
    {
      flat_map_url: "https://cdn.aratel.com/3d/dh_bangbae_84a_draco.glb",
      draco_compressed: true,
      compression_ratio: "70%",
      furniture_catalog: [
        {
          id: "furn_101",
          brand: "B&B Italia",
          name: "Camaleonda Sofa",
          model_3d_url: "https://cdn.aratel.com/3d/sofa_bb_draco.glb",
          draco_compressed: true,
          price: 18500000,
          stock: 3
        }
      ]
    }
  end
end

