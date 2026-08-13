require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
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

  test "should logout" do
    post demo_login_path(preset: "gold")
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_nil session[:user_id]
  end
end
