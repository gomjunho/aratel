require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first || User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    post demo_login_path(user_id: @user.id)
  end

  test "should get profile show view with asset verification links" do
    get profile_path
    assert_response :success
    assert_select "h1", text: /내 정보 및 자산 인증 관리/
    assert_select "h3", text: /자산 인증 및 등기부 연동 관리/
    assert_select "a", text: /본인확인 & 등기부 연동 대시보드/
    assert_select "a", text: /VVIP 자산 증빙 서류 제출/
  end
end
