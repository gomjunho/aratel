class ApplicationController < ActionController::Base
  allow_browser versions: :modern, block: false

  before_action :authenticate_user!

  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user!
    return if active_admin_or_devise_controller?

    unless user_signed_in?
      redirect_to login_path, alert: "로그인이 필요한 서비스입니다. 입주민 인증 후 이용 가능합니다."
    end
  end

  def active_admin_or_devise_controller?
    self.class.name.start_with?("ActiveAdmin::") || self.class.name.start_with?("Admin::") || is_a?(DeviseController)
  end

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
