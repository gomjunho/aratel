require "test_helper"

class CommunityPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101",
      tier: "GOLD",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    )
    post demo_login_path(user_id: @user.id)

    @global_post = CommunityPost.create!(
      board_type: "GLOBAL",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "홍길동",
      title: "전체 공동 안건",
      content: "전체 단지 회원들과 소통하는 글입니다."
    )

    @complex_named_post = CommunityPost.create!(
      board_type: "COMPLEX_NAMED",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "홍길동",
      title: "방배 기명 안건",
      content: "101동 입주민 안건입니다."
    )

    @complex_anon_post = CommunityPost.create!(
      board_type: "COMPLEX_ANONYMOUS",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "홍길동",
      is_anonymous: true,
      title: "방배 익명 제안",
      content: "솔직한 입주민 의견입니다."
    )

    @lounge_post = LoungePost.create!(
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

  test "should get index for all board aggregate feed" do
    get community_posts_path(board_type: "ALL")
    assert_response :success
    assert_select "span", text: /📋 전체 커뮤니티 & 암호화 라운지/
    assert_select "h3", text: "전체 공동 안건"
    assert_select "h3", text: "방배 기명 안건"
    assert_select "h4", text: "2026 하반기 종합소득세 및 증여 절세 노하우"
  end

  test "should get index for encrypted lounge tab" do
    get community_posts_path(board_type: "ENCRYPTED_LOUNGE")
    assert_response :success
    assert_select "h4", text: "2026 하반기 종합소득세 및 증여 절세 노하우"
  end

  test "should get index for encrypted lounge tab when empty" do
    LoungePost.destroy_all
    get community_posts_path(board_type: "ENCRYPTED_LOUNGE")
    assert_response :success
    assert_select "h4", text: "2026 하반기 종합소득세 및 증여 절세 노하우"
  end

  test "should get index for global board" do
    get community_posts_path(board_type: "GLOBAL")
    assert_response :success
    assert_select "div", text: /디에이치 방배 - 홍길동/
    assert_select "h3", text: "전체 공동 안건"
  end

  test "should get index for complex named board" do
    get community_posts_path(board_type: "COMPLEX_NAMED")
    assert_response :success
    assert_select "div", text: /101동 - 홍길동/
    assert_select "h3", text: "방배 기명 안건"
  end

  test "should get index for complex anonymous board" do
    get community_posts_path(board_type: "COMPLEX_ANONYMOUS")
    assert_response :success
    assert_select "div", text: /익명 \(AI Clean Signal\)/
    assert_select "h3", text: "방배 익명 제안"
  end

  test "should get new post view" do
    get new_community_post_path(board_type: "GLOBAL")
    assert_response :success
    assert_select "h1", text: /커뮤니티 게시글 작성/
  end

  test "should create global post using user name as nickname" do
    assert_difference("CommunityPost.count", 1) do
      post community_posts_path, params: {
        community_post: {
          board_type: "GLOBAL",
          title: "전체 주차장 규칙 공유",
          content: "공동 에티켓 공유합니다."
        }
      }
    end
    assert_redirected_to community_posts_path(board_type: "GLOBAL")
    follow_redirect!
    assert_select "div", text: /디에이치 방배 - 홍길동/
  end

  test "should create complex anonymous post" do
    assert_difference("CommunityPost.count", 1) do
      post community_posts_path, params: {
        community_post: {
          board_type: "COMPLEX_ANONYMOUS",
          title: "익명 커뮤니티 건의",
          content: "익명 건의드립니다."
        }
      }
    end
    assert_redirected_to community_posts_path(board_type: "COMPLEX_ANONYMOUS")
    follow_redirect!
    assert_select "div", text: /익명 \(AI Clean Signal\)/
  end
end
