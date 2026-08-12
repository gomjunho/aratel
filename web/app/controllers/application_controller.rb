class ApplicationController < ActionController::Base
  allow_browser versions: :modern, block: false

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.first || User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
  end
end
