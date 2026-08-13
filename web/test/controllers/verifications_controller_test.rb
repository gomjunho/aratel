require "test_helper"

class VerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
    post demo_login_path(user_id: @user.id)
  end

  test "should get verification status dashboard" do
    get verification_url
    assert_response :success
    assert_select "h1", text: /인증 및 멤버십 대시보드|ARATEL Verification/
  end

  test "should render multi-step verification wizard stepper and 1-tap retry option" do
    get verification_url
    assert_response :success
    assert_select ".verification-wizard-stepper"
    assert_select ".step-wizard-item", count: 3
    assert_select "button, a, input", text: /1-Tap|재시도/
  end

  test "should submit identity verification via web" do
    post identity_verify_verification_url, params: {
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    }
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-success", text: /본인확인이 완료되었습니다/
  end

  test "should submit identity verification via API" do
    post api_v1_auth_identity_verify_url, params: {
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["verification_token"].present?
    assert_equal "홍*동", json["masked_name"]
  end

  test "should sync trust api registry via web" do
    post trust_api_sync_verification_url, params: {
      verification_token: "ver_tok_8f9a2b1c",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    }
    assert_redirected_to verification_url
    follow_redirect!
    assert_select ".alert-success", text: /등기부 연동이 완료되었습니다/
  end

  test "should sync trust api registry via API" do
    post api_v1_verification_trust_api_sync_url, params: {
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
  end

  test "should get user tier via API" do
    @user.verify_identity!
    @user.sync_trust_api!(complex_name: "디에이치 방배", building_number: "101동", unit_number: "1502호")

    get api_v1_users_me_tier_url, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "GOLD", json["tier"]
    assert_includes json["badges"], "VERIFIED_OWNER"
    assert_equal "디에이치 방배", json["complex_name"]
    assert_equal "101동 1502호", json["building_unit"]
    assert_equal true, json["security_profile"]["screen_capture_prevented"]
  end
end
