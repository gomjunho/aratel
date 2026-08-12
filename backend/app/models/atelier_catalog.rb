class AtelierCatalog
  def self.fetch_flat_maps
    {
      flat_map_url: "https://storage.aratel.com/3d/dh_bangbae_84a.gltf",
      furniture_catalog: [
        {
          id: "furn_101",
          brand: "B&B Italia",
          name: "Camaleonda Sofa",
          model_3d_url: "https://storage.aratel.com/3d/sofa_bb.gltf",
          price: 18500000,
          stock: 3
        }
      ]
    }
  end
end
