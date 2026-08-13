require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path
    assert_response :success
    assert_select "h1", text: /ARATEL/
  end

  test "should redirect to root_path when already logged in" do
    post demo_login_path(preset: "gold")
    get login_path
    assert_redirected_to root_path
  end

  test "should demo login gold resident" do
    post demo_login_path(preset: "gold")
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_not_nil session[:user_id]
  end

  test "should demo login diamond vvip" do
    post demo_login_path(preset: "diamond")
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_not_nil session[:user_id]
  end

  test "should login via user_id param" do
    user = User.create!(name: "테스트유저", phone_number: "01077778888", birth_date: "19900101")
    post demo_login_path(user_id: user.id)
    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end

  test "should login via phone number param" do
    post login_path(name: "김철수", phone_number: "01055554444")
    assert_redirected_to root_path
    assert_not_nil session[:user_id]
  end

  test "should logout" do
    post demo_login_path(preset: "gold")
    delete logout_path
    assert_redirected_to login_path
    follow_redirect!
    assert_response :success
    assert_nil session[:user_id]
  end
end
