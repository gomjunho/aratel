module Api
  module V1
    module Users
      class TiersController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def show
          user_id = request.headers["X-User-Id"].presence || params[:user_id]
          user = User.find_by(user_id: user_id) if user_id.present?
          user ||= User.find_or_create_by!(user_id: "usr_1001") do |u|
            u.name = "홍길동"
            u.tier = "DIAMOND"
            u.badges = ["VERIFIED_OWNER", "DIAMOND_BLACK"]
            u.complex_name = "디에이치 방배"
            u.building_number = "101동"
            u.unit_number = "1502호"
          end

          render json: {
            user_id: user.user_id,
            tier: user.tier,
            badges: user.badges_list,
            complex_name: user.complex_name,
            building_unit: user.building_unit,
            security_profile: user.security_profile
          }, status: :ok
        end
      end
    end
  end
end
