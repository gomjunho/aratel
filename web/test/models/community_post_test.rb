require "test_helper"

class CommunityPostTest < ActiveSupport::TestCase
  test "global board author display format" do
    post = CommunityPost.new(
      board_type: "GLOBAL",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "푸른하늘",
      title: "전체 공동 안건",
      content: "모든 단지 공통 문의사항입니다."
    )
    assert post.valid?
    assert_equal "디에이치 방배 - 푸른하늘", post.author_display_name
    assert_equal "🌐 [전체공동]", post.board_type_emoji_badge
  end

  test "global board author display with default nil values" do
    post = CommunityPost.new(board_type: "GLOBAL")
    assert_equal "전체단지 - 입주민", post.author_display_name
  end

  test "complex named board author display format" do
    post = CommunityPost.new(
      board_type: "COMPLEX_NAMED",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "푸른하늘",
      title: "단지 기명 안건",
      content: "101동 주차장 관련 문의입니다."
    )
    assert post.valid?
    assert_equal "101동 - 푸른하늘", post.author_display_name
    assert_equal "🏢 [단지기명]", post.board_type_emoji_badge
  end

  test "complex named board author display with default nil values" do
    post = CommunityPost.new(board_type: "COMPLEX_NAMED")
    assert_equal "101동 - 입주민", post.author_display_name
  end

  test "complex anonymous board author display format" do
    post = CommunityPost.new(
      board_type: "COMPLEX_ANONYMOUS",
      complex_name: "디에이치 방배",
      building_number: "101동",
      nickname: "푸른하늘",
      is_anonymous: true,
      title: "단지 익명 안건",
      content: "익명으로 제안합니다."
    )
    assert post.valid?
    assert_equal "익명 (AI Clean Signal)", post.author_display_name
    assert_equal "🔒 [단지익명]", post.board_type_emoji_badge
  end

  test "fallback author display name and emoji badge for unknown board_type" do
    post = CommunityPost.new(board_type: "OTHER", nickname: "테스터")
    assert_equal "테스터", post.author_display_name
    assert_equal "📋 [기타]", post.board_type_emoji_badge

    post_empty = CommunityPost.new(board_type: "OTHER")
    assert_equal "입주민", post_empty.author_display_name
  end

  test "invalid without required attributes" do
    post = CommunityPost.new
    assert_not post.valid?
    assert_includes post.errors[:board_type], "can't be blank"
    assert_includes post.errors[:title], "can't be blank"
  end

  test "ransackable helpers return array" do
    assert_kind_of Array, CommunityPost.ransackable_attributes
    assert_kind_of Array, CommunityPost.ransackable_associations
  end
end
