require "test_helper"

class TierEvidencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
  end

  test "should get new tier evidence page" do
    get new_tier_evidence_url
    assert_response :success
    assert_select "h1", text: /VVIP 자산 증빙 제출|Tier Evidence Submission/
  end

  test "should create tier evidence via web" do
    post tier_evidences_url, params: {
      tier_evidence: {
        evidence_type: "INCOME_CERT",
        document_url: "https://storage.aratel.com/docs/income_2025.pdf",
        instagram_handle: "@vip_user",
        referral_code: "DIAMOND_777",
        target_tier: "DIAMOND"
      }
    }
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-success", text: /자산 증빙 서류가 제출되었습니다/
  end

  test "should handle failed creation via web" do
    post tier_evidences_url, params: {
      tier_evidence: {
        evidence_type: "",
        document_url: ""
      }
    }
    assert_response :unprocessable_entity
  end

  test "should create tier evidence via API" do
    post api_v1_verification_tier_evidence_url, params: {
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      instagram_handle: "@vip_user",
      referral_code: "DIAMOND_777"
    }, as: :json

    assert_response :accepted
    json = JSON.parse(response.body)
    assert json["submission_id"].present?
    assert_equal "UNDER_REVIEW", json["status"]
    assert_equal "DIAMOND", json["target_tier"]
  end

  test "should handle failed creation via API" do
    post api_v1_verification_tier_evidence_url, params: {
      evidence_type: "",
      document_url: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["error"].present?
  end

  test "should show tier evidence submission details" do
    evidence = TierEvidence.create!(
      user: @user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      instagram_handle: "@vip_user",
      referral_code: "DIAMOND_777"
    )

    get tier_evidence_url(evidence)
    assert_response :success
    assert_select "h2", text: /증빙 제출 상세 정보|Evidence Details/
  end
end
