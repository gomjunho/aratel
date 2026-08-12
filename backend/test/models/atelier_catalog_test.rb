require "test_helper"

class AtelierCatalogTest < ActiveSupport::TestCase
  test "flat_maps returns default flat_map_url and furniture_catalog" do
    data = AtelierCatalog.fetch_flat_maps

    assert_equal "https://storage.aratel.com/3d/dh_bangbae_84a.gltf", data[:flat_map_url]
    assert_kind_of Array, data[:furniture_catalog]
    assert_not_empty data[:furniture_catalog]

    item = data[:furniture_catalog].first
    assert_equal "furn_101", item[:id]
    assert_equal "B&B Italia", item[:brand]
    assert_equal "Camaleonda Sofa", item[:name]
    assert_equal "https://storage.aratel.com/3d/sofa_bb.gltf", item[:model_3d_url]
    assert_equal 18500000, item[:price]
    assert_equal 3, item[:stock]
  end
end
