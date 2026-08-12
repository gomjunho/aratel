require "test_helper"

class LoungePostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    @post = LoungePost.create!(
      post_id: "post_7001",
      anonymous_nickname: "은밀한 자산가 42",
      verified_badge: "VERIFIED_OWNER",
      tier: "DIAMOND",
      complex_name: "디에이치 방배",
      title: "2026 하반기 종합소득세 및 증여 절세 노하우",
      content_encrypted: "EncryptedBodyPayload...",
      is_diamond_weighted: true,
      trust_score: 98
    )
  end

  test "should get index view feed" do
    get lounge_posts_path
    assert_response :success
    assert_select "h1", text: /익명 라운지 피드/
    assert_select "div", text: /은밀한 자산가 42/
    assert_select "div", text: /2026 하반기 종합소득세/
  end

  test "should get new post view" do
    get new_lounge_post_path
    assert_response :success
    assert_select "h1", text: /라운지 게시글 작성/
  end

  test "should create post via web form" do
    assert_difference("LoungePost.count", 1) do
      post lounge_posts_path, params: { lounge_post: { title: "단지 내 스카이라운지 제안", content: "운영 시간 연장 요청" } }
    end
    assert_redirected_to lounge_posts_path
    follow_redirect!
    assert_select "div", text: /단지 내 스카이라운지 제안/
  end

  test "should return api lounge posts feed" do
    get api_v1_lounge_posts_path
    assert_response :success
    json = JSON.parse(response.body)
    assert_kind_of Array, json["posts"]
    assert_equal "post_7001", json["posts"].first["id"]
    assert_equal "은밀한 자산가 42", json["posts"].first["anonymous_nickname"]
  end

  test "should create post via api" do
    assert_difference("LoungePost.count", 1) do
      post api_v1_lounge_posts_path, params: { title: "단지 내 스카이라운지 조식 이용 관련 제안", content: "조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다." }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["id"].start_with?("post_")
    assert_equal true, json["clean_signal_verified"]
    assert_equal 50, json["earned_points"]
    assert_equal "PUBLISHED", json["status"]
  end
end
