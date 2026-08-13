class ApplicationController < ActionController::Base
  allow_browser versions: :modern, block: false

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= if session[:user_id].present?
      User.find_by(id: session[:user_id])
    else
      User.first || User.create!(
        name: "홍길동",
        phone_number: "01012345678",
        birth_date: "19800101",
        tier: "GOLD",
        complex_name: "디에이치 방배",
        building_number: "101동",
        unit_number: "1502호"
      )
    end
  end

  def user_signed_in?
    session[:user_id].present?
  end
end
