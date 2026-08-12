require "test_helper"

class LoungePostTest < ActiveSupport::TestCase
  test "valid lounge post assigns post_id and defaults on validation" do
    post = LoungePost.new(
      title: "단지 내 스카이라운지 조식 이용 관련 제안",
      content: "조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다."
    )
    assert post.valid?
    assert_not_nil post.post_id
    assert post.post_id.start_with?("post_")
    assert_equal "PUBLISHED", post.status
    assert_equal true, post.clean_signal_verified
    assert_equal 50, post.earned_points
  end

  test "invalid without title or content" do
    post = LoungePost.new(title: "", content: "")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
    assert_includes post.errors[:content], "can't be blank"
  end

  test "as_feed_json formats post for feed list" do
    post = lounge_posts(:one)
    json = post.as_feed_json
    assert_equal "post_7001", json[:id]
    assert_equal "은밀한 자산가 42", json[:anonymous_nickname]
    assert_equal "VERIFIED_OWNER", json[:verified_badge]
    assert_equal "DIAMOND", json[:tier]
    assert_equal "디에이치 방배", json[:complex_name]
    assert_equal "2026 하반기 종합소득세 및 증여 절세 노하우", json[:title]
    assert_equal "EncryptedBodyPayload...", json[:content_encrypted]
    assert_equal true, json[:is_diamond_weighted]
    assert_equal 98, json[:trust_score]
    assert_not_nil json[:created_at]
  end

  test "as_created_json formats post response after creation" do
    post = lounge_posts(:one)
    json = post.as_created_json
    assert_equal "post_7001", json[:id]
    assert_equal true, json[:clean_signal_verified]
    assert_equal 50, json[:earned_points]
    assert_equal "PUBLISHED", json[:status]
  end
end
