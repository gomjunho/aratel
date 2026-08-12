require "test_helper"

class Api::V1::Verification::TierEvidencesControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/verification/tier_evidence with valid params returns 202" do
    post "/api/v1/verification/tier_evidence", params: {
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      instagram_handle: "@vip_user",
      referral_code: "DIAMOND_777"
    }, as: :json

    assert_response :accepted
    json = JSON.parse(response.body)
    assert json["submission_id"].start_with?("sub_")
    assert_equal "UNDER_REVIEW", json["status"]
    assert_equal "DIAMOND", json["target_tier"]
    assert_not_nil json["submitted_at"]
  end

  test "POST /api/v1/verification/tier_evidence with invalid params returns 422" do
    post "/api/v1/verification/tier_evidence", params: {
      evidence_type: "",
      document_url: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
  end
end
