class LoungePostsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_index, :api_create]

  def index
    @posts = LoungePost.order(created_at: :desc)
  end

  def new
    @lounge_post = LoungePost.new
  end

  def create
    post_params = params.require(:lounge_post).permit(:title, :content)
    post = LoungePost.create!(
      post_id: "post_#{SecureRandom.random_number(1000..9999)}",
      anonymous_nickname: "은밀한 자산가 #{SecureRandom.random_number(10..99)}",
      verified_badge: "VERIFIED_OWNER",
      tier: current_user.tier.presence || "DIAMOND",
      complex_name: current_user.complex_name.presence || "디에이치 방배",
      title: post_params[:title],
      content_encrypted: post_params[:content],
      is_diamond_weighted: true,
      trust_score: 98,
      clean_signal_verified: true,
      earned_points: 50,
      status: "PUBLISHED"
    )
    redirect_to lounge_posts_path, notice: "게시글이 작성되었습니다."
  end

  def api_index
    posts = LoungePost.order(created_at: :desc)
    render json: {
      posts: posts.map do |p|
        {
          id: p.post_id,
          anonymous_nickname: p.anonymous_nickname,
          verified_badge: p.verified_badge,
          tier: p.tier,
          complex_name: p.complex_name,
          title: p.title,
          content_encrypted: p.content_encrypted,
          is_diamond_weighted: p.is_diamond_weighted,
          trust_score: p.trust_score,
          created_at: p.created_at.iso8601
        }
      end
    }, status: :ok
  end

  def api_create
    title = params[:title]
    content = params[:content]
    post = LoungePost.create!(
      post_id: "post_#{SecureRandom.random_number(1000..9999)}",
      anonymous_nickname: "은밀한 자산가 #{SecureRandom.random_number(10..99)}",
      verified_badge: "VERIFIED_OWNER",
      tier: current_user.tier.presence || "DIAMOND",
      complex_name: current_user.complex_name.presence || "디에이치 방배",
      title: title,
      content_encrypted: content,
      is_diamond_weighted: true,
      trust_score: 98,
      clean_signal_verified: true,
      earned_points: 50,
      status: "PUBLISHED"
    )

    render json: {
      id: post.post_id,
      clean_signal_verified: post.clean_signal_verified,
      earned_points: post.earned_points,
      status: post.status
    }, status: :created
  end
end
