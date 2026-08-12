require "test_helper"

class Api::V1::Verification::TrustApiSyncsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iv = IdentityVerification.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101",
      verification_token: "ver_tok_8f9a2b1c"
    )
  end

  test "POST /api/v1/verification/trust_api_sync with valid verification_token" do
    post "/api/v1/verification/trust_api_sync", params: {
      verification_token: "ver_tok_8f9a2b1c",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "VERIFIED", json["status"]
    assert_equal "홍*동", json["owner_name_masked"]
    assert_equal 100, json["ownership_percentage"]
    assert_equal "VERIFIED_OWNER", json["badge"]
    assert_equal "GOLD", json["assigned_tier"]
    assert_not_nil json["verified_at"]
  end

  test "POST /api/v1/verification/trust_api_sync with invalid token returns 422" do
    post "/api/v1/verification/trust_api_sync", params: {
      verification_token: "invalid_token",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
  end

  test "POST /api/v1/verification/trust_api_sync with missing params returns 422" do
    post "/api/v1/verification/trust_api_sync", params: {
      verification_token: "ver_tok_8f9a2b1c",
      complex_name: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
  end
end
