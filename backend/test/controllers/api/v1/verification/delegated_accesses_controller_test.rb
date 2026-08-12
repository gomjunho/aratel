require "test_helper"

class Api::V1::Verification::DelegatedAccessesControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/verification/delegated_access with valid params" do
    post "/api/v1/verification/delegated_access", params: {
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)
    assert json["delegation_id"].start_with?("del_")
    assert_equal "PENDING_OWNER_APPROVAL", json["status"]
    assert_not_nil json["requested_at"]
  end

  test "POST /api/v1/verification/delegated_access with invalid params returns 422" do
    post "/api/v1/verification/delegated_access", params: {
      relationship: "",
      document_url: ""
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
  end

  test "POST /api/v1/verification/delegated_access/:id/approve with approved true" do
    da = DelegatedAccess.create!(
      delegation_id: "del_9981",
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post "/api/v1/verification/delegated_access/del_9981/approve", params: {
      approved: true
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "del_9981", json["delegation_id"]
    assert_equal "APPROVED", json["status"]
    assert_equal "RESIDENT", json["granted_badge"]
    assert_equal "RESIDENT", json["role"]
  end

  test "POST /api/v1/verification/delegated_access/:id/approve with approved false" do
    da = DelegatedAccess.create!(
      delegation_id: "del_9982",
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    post "/api/v1/verification/delegated_access/del_9982/approve", params: {
      approved: false
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "del_9982", json["delegation_id"]
    assert_equal "REJECTED", json["status"]
    assert_nil json["granted_badge"]
    assert_nil json["role"]
  end

  test "POST /api/v1/verification/delegated_access/:id/approve with non-existent id returns 404" do
    post "/api/v1/verification/delegated_access/non_existent/approve", params: {
      approved: true
    }, as: :json

    assert_response :not_found
    json = JSON.parse(response.body)
    assert_equal "error", json["status"]
  end
end
