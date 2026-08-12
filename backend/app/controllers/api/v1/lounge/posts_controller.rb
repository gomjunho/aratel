module Api
  module V1
    module Lounge
      class PostsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def index
          posts = LoungePost.order(created_at: :desc).map(&:as_feed_json)
          render json: { posts: posts }, status: :ok
        end

        def create
          post = LoungePost.new(
            title: params[:title],
            content: params[:content]
          )

          if post.save
            render json: post.as_created_json, status: :created
          else
            render json: {
              status: "error",
              errors: post.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
