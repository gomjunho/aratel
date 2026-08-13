module Api
  module V1
    module Home
      class WelcomesController < ApplicationController
        def show
          cache_key = "welcome_home_#{params[:complex_name] || 'default'}"
          cached_data = Rails.cache.fetch(cache_key, expires_in: 30.seconds) do
            HomeWelcome.new.as_json
          end
          render json: cached_data, status: :ok
        end

      end
    end
  end
end
