module Api
  module V1
    module Lounge
      class PostsController < ApplicationController
        def index
          posts = LoungePost.order(created_at: :desc).map(&:as_feed_json)
          render json: { posts: posts }, status: :ok
        end

        def create
          p_params = post_params
          post = LoungePost.new(
            title: p_params[:title],
            content: p_params[:content]
          )

          if current_user.present?
            post.tier = current_user.tier
            post.complex_name = current_user.complex_name if current_user.complex_name.present?
          end

          if post.save
            render json: post.as_created_json, status: :created
          else
            render json: {
              status: "error",
              errors: post.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def post_params
          params[:post].present? ? params.require(:post).permit(:title, :content) : params.permit(:title, :content)
        end
      end
    end
  end
end
