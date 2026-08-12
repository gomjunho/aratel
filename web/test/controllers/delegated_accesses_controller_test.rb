require "test_helper"

class DelegatedAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
  end

  test "should create delegated access request via web" do
    post delegated_accesses_url, params: {
      delegated_access: {
        relationship: "FAMILY",
        document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
      }
    }
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-success", text: /위임 신청이 완료되었습니다/
  end

  test "should handle failed creation via web" do
    post delegated_accesses_url, params: {
      delegated_access: {
        relationship: "",
        document_url: ""
      }
    }
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-warning", text: /위임 신청 중 오류가 발생했습니다/
  end

  test "should reject delegated access request via web" do
    req = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post approve_delegated_access_url(req, approved: "false")
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-warning", text: /위임 신청이 거절되었습니다/
    assert_equal "REJECTED", req.reload.status
  end

  test "should approve delegated access request via web" do
    req = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post approve_delegated_access_url(req, approved: "true")
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-success", text: /위임 신청이 승인되었습니다/
    assert_equal "APPROVED", req.reload.status
  end

  test "should create delegated access request via API" do
    post api_v1_verification_delegated_access_url, params: {
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)
    assert json["delegation_id"].present?
    assert_equal "PENDING_OWNER_APPROVAL", json["status"]
  end

  test "should handle failed creation via API" do
    post api_v1_verification_delegated_access_url, params: {
      relationship: "",
      document_url: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["error"].present?
  end

  test "should approve delegated access request via API" do
    req = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post "/api/v1/verification/delegated_access/#{req.id}/approve", params: {
      approved: true
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "APPROVED", json["status"]
    assert_equal "RESIDENT", json["granted_badge"]
  end

  test "should reject delegated access request via API using delegation_id" do
    req = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post "/api/v1/verification/delegated_access/#{req.delegation_id}/approve", params: {
      approved: false
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "REJECTED", json["status"]
  end
end
