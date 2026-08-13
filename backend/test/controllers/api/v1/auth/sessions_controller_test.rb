require "test_helper"

class Api::V1::Auth::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      user_id: "usr_auth_test_101",
      email: "test@aratel.com",
      password: "password123",
      name: "테스트 소유주",
      tier: "DIAMOND"
    )
  end

  test "should register new user and return JWT token" do
    post api_v1_auth_register_url, params: {
      email: "newuser@aratel.com",
      password: "password123",
      name: "신규회원"
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)
    assert_not_nil json["token"]
    assert_equal "신규회원", json["name"]
  end

  test "should login existing user and return JWT token" do
    post api_v1_auth_login_url, params: {
      user_id: @user.user_id,
      password: "password123"
    }, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_not_nil json["token"]
    assert_equal @user.user_id, json["user_id"]
  end

  test "should get current user profile with valid JWT token" do
    token = AuthService.encode(user_id: @user.user_id, tier: @user.tier)

    get api_v1_auth_me_url, headers: {
      "Authorization" => "Bearer #{token}"
    }, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @user.user_id, json["user_id"]
  end

  test "should return unauthorized for invalid credentials login" do
    post api_v1_auth_login_url, params: {
      user_id: "non_existent_user",
      password: "wrong_password"
    }, as: :json

    assert_response :unauthorized
  end

  test "should return unprocessable entity for failed registration" do
    post api_v1_auth_register_url, params: {
      tier: nil,
      user_id: nil
    }, as: :json

    assert_response :unprocessable_entity
  end

  test "AuthService handling invalid token" do
    assert_nil AuthService.decode("invalid.token.str")
  end

  test "should return unauthorized for unauthenticated me request" do
    get api_v1_auth_me_url, as: :json
    assert_response :unauthorized
  end
end
