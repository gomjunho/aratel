class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern, if: -> { request.format.html? }

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= find_user_from_token
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    unless logged_in?
      render json: { error: "UNAUTHORIZED", message: "인증이 필요한 요청입니다." }, status: :unauthorized
    end
  end

  private

  def find_user_from_token
    header = request.headers["Authorization"]
    return nil if header.blank?

    token = header.split(" ").last
    payload = AuthService.decode(token)
    return nil if payload.blank?

    User.find_by(user_id: payload[:user_id])
  end
end
