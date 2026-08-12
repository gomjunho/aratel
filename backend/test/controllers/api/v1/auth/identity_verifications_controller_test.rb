require "test_helper"

class Api::V1::Auth::IdentityVerificationsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/auth/identity_verify with valid params" do
    post "/api/v1/auth/identity_verify", params: {
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["verification_token"].start_with?("ver_tok_")
    assert_equal "홍*동", json["masked_name"]
    assert_not_nil json["verified_at"]
  end

  test "POST /api/v1/auth/identity_verify with invalid params returns 422" do
    post "/api/v1/auth/identity_verify", params: {
      name: "",
      phone_number: "01012345678"
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
    assert_not_nil json["errors"]
  end
end
