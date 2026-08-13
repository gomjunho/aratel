class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]

  def new
    if user_signed_in?
      redirect_to root_path, notice: "이미 로그인되어 있습니다."
    end
  end

  def create
    user = if params[:user_id].present?
      User.find_by(id: params[:user_id])
    elsif params[:preset] == "diamond"
      User.find_or_create_by!(name: "이서진") do |u|
        u.phone_number = "01099998888"
        u.birth_date = "19750505"
        u.tier = "DIAMOND_BLACK"
        u.complex_name = "한남 더힐"
        u.building_number = "102동"
        u.unit_number = "801호"
        u.badges_list = ["VERIFIED_OWNER", "RESIDENT", "DIAMOND_BLACK"]
      end
    elsif params[:phone_number].present?
      User.find_by(phone_number: params[:phone_number]) || User.find_or_create_by!(name: params[:name].presence || "홍길동") do |u|
        u.phone_number = params[:phone_number]
        u.birth_date = "19800101"
        u.tier = "GOLD"
        u.complex_name = "디에이치 방배"
        u.building_number = "101동"
        u.unit_number = "1502호"
        u.badges_list = ["VERIFIED_OWNER", "RESIDENT"]
      end
    else
      User.find_or_create_by!(name: "홍길동") do |u|
        u.phone_number = "01012345678"
        u.birth_date = "19800101"
        u.tier = "GOLD"
        u.complex_name = "디에이치 방배"
        u.building_number = "101동"
        u.unit_number = "1502호"
        u.badges_list = ["VERIFIED_OWNER", "RESIDENT"]
      end
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "#{user.name} 님으로 성공적으로 로그인되었습니다. (#{user.complex_name} / #{user.tier})"
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "로그아웃되었습니다."
  end
end
