require "test_helper"

class Admin::VerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
    @evidence = TierEvidence.create!(
      user: @user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      target_tier: "DIAMOND"
    )
    @delegation = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )
  end

  test "should get admin verification queue index" do
    get admin_verifications_url
    assert_response :success
    assert_select "h1", text: /관리자 인증 심사 대기열|Admin Verification Queue/
  end

  test "should filter admin verification queue by status" do
    get admin_verifications_url(status: "UNDER_REVIEW")
    assert_response :success
  end

  test "should show verification item details in admin" do
    get admin_verification_url(@evidence)
    assert_response :success
    assert_select "h2", text: /서류 심사 상세 정보|Verification Submission Review/
  end

  test "should show delegation item details in admin" do
    get admin_verification_url(@delegation)
    assert_response :success
    assert_select "h2", text: /서류 심사 상세 정보|Verification Submission Review/
  end

  test "should approve tier evidence in admin" do
    post approve_tier_evidence_admin_verification_url(@evidence), params: {
      admin_notes: "Checked official tax document"
    }
    assert_redirected_to admin_verifications_url
    follow_redirect!
    assert_select ".alert-success", text: /자산 증빙 서류가 승인되었습니다/
    assert_equal "DIAMOND", @user.reload.tier
  end

  test "should reject tier evidence in admin" do
    post reject_tier_evidence_admin_verification_url(@evidence), params: {
      admin_notes: "Document illegible"
    }
    assert_redirected_to admin_verifications_url
    follow_redirect!
    assert_select ".alert-warning", text: /자산 증빙 서류가 반려되었습니다/
    assert_equal "REJECTED", @evidence.reload.status
  end

  test "should approve delegation in admin" do
    post approve_delegation_admin_verification_url(@delegation)
    assert_redirected_to admin_verifications_url
    follow_redirect!
    assert_select ".alert-success", text: /권한 위임 요청이 승인되었습니다/
    assert_equal "APPROVED", @delegation.reload.status
  end

  test "should reject delegation in admin" do
    post reject_delegation_admin_verification_url(@delegation)
    assert_redirected_to admin_verifications_url
    follow_redirect!
    assert_select ".alert-warning", text: /권한 위임 요청이 거절되었습니다/
    assert_equal "REJECTED", @delegation.reload.status
  end
end
