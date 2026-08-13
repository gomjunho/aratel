require "test_helper"

class Api::V1::Lounge::PostsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/lounge/posts returns posts feed" do
    get "/api/v1/lounge/posts"

    assert_response :success
    json = JSON.parse(response.body)

    assert_kind_of Array, json["posts"]
    assert_not_empty json["posts"]

    post = json["posts"].first
    assert_equal "post_7001", post["id"]
    assert_equal "은밀한 자산가 42", post["anonymous_nickname"]
    assert_equal "VERIFIED_OWNER", post["verified_badge"]
    assert_equal "DIAMOND", post["tier"]
    assert_equal "디에이치 방배", post["complex_name"]
    assert_equal "2026 하반기 종합소득세 및 증여 절세 노하우", post["title"]
    assert_equal "EncryptedBodyPayload...", post["content_encrypted"]
    assert_equal true, post["is_diamond_weighted"]
    assert_equal 98, post["trust_score"]
    assert_not_nil post["created_at"]
  end

  test "POST /api/v1/lounge/posts with valid params creates post" do
    post "/api/v1/lounge/posts", params: {
      title: "단지 내 스카이라운지 조식 이용 관련 제안",
      content: "조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다."
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)

    assert json["id"].start_with?("post_")
    assert_equal true, json["clean_signal_verified"]
    assert_equal 50, json["earned_points"]
    assert_equal "PUBLISHED", json["status"]
  end

  test "POST /api/v1/lounge/posts with authenticated user params" do
    user = User.create!(user_id: "usr_lounge_99", name: "라운지유저", tier: "DIAMOND", complex_name: "디에이치 방배")
    token = AuthService.encode(user_id: user.user_id, tier: user.tier)

    post "/api/v1/lounge/posts", params: {
      post: {
        title: "인증 유저 게시글",
        content: "내용입니다."
      }
    }, headers: {
      "Authorization" => "Bearer #{token}"
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)
    assert json["id"].start_with?("post_")
  end

  test "POST /api/v1/lounge/posts with invalid params returns 422" do
    post "/api/v1/lounge/posts", params: {
      title: "",
      content: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)

    assert_equal "error", json["status"]
    assert_not_nil json["errors"]
  end
end
