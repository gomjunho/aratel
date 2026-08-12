require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates user with default values" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    assert_equal "BRONZE", user.tier
    assert_equal true, user.screen_capture_prevented
    assert_equal true, user.privacy_masked
    assert_includes user.badges, "BRONZE_METALLIC"
  end

  test "verifies identity and generates verification token" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    user.verify_identity!
    assert user.verification_token.present?
    assert_equal "홍*동", user.masked_name

    short_user = User.new(name: "김철")
    assert_equal "김*", short_user.masked_name

    empty_user = User.new(name: "")
    assert_equal "", empty_user.masked_name
  end

  test "syncs trust registry api and upgrades tier and badge" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    user.verify_identity!
    user.sync_trust_api!(complex_name: "디에이치 방배", building_number: "101동", unit_number: "1502호")

    assert_equal "디에이치 방배", user.complex_name
    assert_equal "101동", user.building_number
    assert_equal "1502호", user.unit_number
    assert_equal 100, user.ownership_percentage
    assert_equal "VERIFIED_OWNER", user.badge
    assert_equal "GOLD", user.tier
    assert_includes user.badges, "VERIFIED_OWNER"
  end

  test "security profile JSON representation" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    profile = user.security_profile
    assert_equal true, profile[:screen_capture_prevented]
    assert_equal true, profile[:privacy_masked]
  end
end
