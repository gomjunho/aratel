require "test_helper"

class LoungePostTest < ActiveSupport::TestCase
  test "validates ransackable attributes and associations" do
    assert_kind_of Array, LoungePost.ransackable_attributes
    assert_equal [], LoungePost.ransackable_associations
  end

  test "sanitizes title and content_encrypted against XSS script tags" do
    post = LoungePost.new(
      post_id: "test_post_xss",
      title: "Title<script>alert('xss')</script>",
      content_encrypted: "Payload<img src=x onerror=alert(1)>"
    )
    post.valid?
    refute_includes post.title, "<script>"
    refute_includes post.content_encrypted, "onerror="
  end

end
