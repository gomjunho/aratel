class CommunityPostsController < ApplicationController
  def index
    @board_type = params[:board_type].presence || "ALL"
    @posts = case @board_type
    when "GLOBAL"
      CommunityPost.where(board_type: "GLOBAL").order(created_at: :desc)
    when "COMPLEX_NAMED"
      CommunityPost.where(board_type: "COMPLEX_NAMED", complex_name: current_user.complex_name).order(created_at: :desc)
    when "COMPLEX_ANONYMOUS"
      CommunityPost.where(board_type: "COMPLEX_ANONYMOUS", complex_name: current_user.complex_name).order(created_at: :desc)
    when "ENCRYPTED_LOUNGE"
      []
    else
      # "ALL" or default: 모아보기 (전체 공동 + 소속 단지 게시글)
      CommunityPost.where("board_type = 'GLOBAL' OR complex_name = ?", current_user.complex_name).order(created_at: :desc)
    end

    @encrypted_posts = LoungePost.order(created_at: :desc)
    if @encrypted_posts.empty?
      @encrypted_posts = [
        LoungePost.create!(
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
      ]
    end
  end

  def new
    @board_type = params[:board_type].presence || "GLOBAL"
    @board_type = "GLOBAL" if @board_type == "ALL"
    @community_post = CommunityPost.new(board_type: @board_type)
  end

  def create
    post_params = params.require(:community_post).permit(:board_type, :title, :content)
    board_type = post_params[:board_type]
    is_anon = (board_type == "COMPLEX_ANONYMOUS")

    @community_post = CommunityPost.create!(
      board_type: board_type,
      complex_name: current_user.complex_name,
      building_number: current_user.building_number,
      nickname: current_user.name,
      is_anonymous: is_anon,
      title: post_params[:title],
      content: post_params[:content],
      user: current_user
    )

    redirect_to community_posts_path(board_type: board_type), notice: "게시글이 성공적으로 등록되었습니다."
  end
end
