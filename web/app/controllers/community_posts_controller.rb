class CommunityPostsController < ApplicationController
  def index
    @board_type = params[:board_type].presence || "GLOBAL"
    @posts = case @board_type
    when "GLOBAL"
      CommunityPost.where(board_type: "GLOBAL").order(created_at: :desc)
    when "COMPLEX_NAMED"
      CommunityPost.where(board_type: "COMPLEX_NAMED", complex_name: current_user.complex_name).order(created_at: :desc)
    when "COMPLEX_ANONYMOUS"
      CommunityPost.where(board_type: "COMPLEX_ANONYMOUS", complex_name: current_user.complex_name).order(created_at: :desc)
    else
      CommunityPost.order(created_at: :desc)
    end
  end

  def new
    @board_type = params[:board_type].presence || "GLOBAL"
    @community_post = CommunityPost.new(board_type: @board_type)
  end

  def create
    post_params = params.require(:community_post).permit(:board_type, :title, :content, :nickname)
    board_type = post_params[:board_type]
    is_anon = (board_type == "COMPLEX_ANONYMOUS")

    @community_post = CommunityPost.create!(
      board_type: board_type,
      complex_name: current_user.complex_name,
      building_number: current_user.building_number,
      nickname: post_params[:nickname].presence || current_user.name,
      is_anonymous: is_anon,
      title: post_params[:title],
      content: post_params[:content],
      user: current_user
    )

    redirect_to community_posts_path(board_type: board_type), notice: "게시글이 성공적으로 등록되었습니다."
  end
end
