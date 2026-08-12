require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user attributes and default values" do
    user = User.new(
      user_id: "usr_1001",
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
    assert user.valid?
    assert_equal "BRONZE", user.tier
    assert_equal true, user.screen_capture_prevented
    assert_equal true, user.privacy_masked
  end

  test "requires user_id" do
    user = User.new(user_id: nil)
    assert_not user.valid?
    assert_includes user.errors[:user_id], "can't be blank"
  end

  test "enforces unique user_id" do
    User.create!(user_id: "usr_1001", name: "홍길동")
    duplicate = User.new(user_id: "usr_1001", name: "김철수")
    assert_not duplicate.valid?
  end

  test "mask_name logic for various name lengths" do
    assert_equal "홍*동", User.mask_name("홍길동")
    assert_equal "이*", User.mask_name("이도")
    assert_equal "홍", User.mask_name("홍")
    assert_equal "A*******r", User.mask_name("Alexander")
    assert_equal "", User.mask_name(nil)
  end

  test "badges_list parsing and serialized assignment" do
    user = User.new(badges: ["VERIFIED_OWNER", "DIAMOND_BLACK"])
    assert_equal ["VERIFIED_OWNER", "DIAMOND_BLACK"], user.badges_list
  end

  test "building_unit formatting" do
    user = User.new(building_number: "101동", unit_number: "1502호")
    assert_equal "101동 1502호", user.building_unit
  end

  test "security_profile formatting" do
    user = User.new(screen_capture_prevented: true, privacy_masked: true)
    expected = {
      "screen_capture_prevented" => true,
      "privacy_masked" => true
    }
    assert_equal expected, user.security_profile
  end
end
