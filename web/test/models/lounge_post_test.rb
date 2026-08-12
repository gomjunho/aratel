require "test_helper"

class LoungePostTest < ActiveSupport::TestCase
  test "validates ransackable attributes and associations" do
    assert_kind_of Array, LoungePost.ransackable_attributes
    assert_equal [], LoungePost.ransackable_associations
  end
end
