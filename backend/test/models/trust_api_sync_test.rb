require "test_helper"

class TrustApiSyncTest < ActiveSupport::TestCase
  test "valid trust api sync attributes and default values" do
    sync = TrustApiSync.new(
      verification_token: "ver_tok_8f9a2b1c",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호",
      owner_name_masked: "홍*동"
    )
    assert sync.valid?
    assert_equal "VERIFIED", sync.status
    assert_equal 100, sync.ownership_percentage
    assert_equal "VERIFIED_OWNER", sync.badge
    assert_equal "GOLD", sync.assigned_tier
    assert_not_nil sync.verified_at
  end

  test "requires verification_token, complex_name, building_number, unit_number" do
    sync = TrustApiSync.new
    assert_not sync.valid?
    assert_includes sync.errors[:verification_token], "can't be blank"
    assert_includes sync.errors[:complex_name], "can't be blank"
    assert_includes sync.errors[:building_number], "can't be blank"
    assert_includes sync.errors[:unit_number], "can't be blank"
  end
end
