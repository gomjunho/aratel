require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "validates ransackable attributes and associations" do
    assert_kind_of Array, AdminUser.ransackable_attributes
    assert_equal [], AdminUser.ransackable_associations
  end
end
