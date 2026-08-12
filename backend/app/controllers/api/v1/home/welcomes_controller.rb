module Api
  module V1
    module Home
      class WelcomesController < ApplicationController
        def show
          welcome = HomeWelcome.new
          render json: welcome.as_json, status: :ok
        end
      end
    end
  end
end
