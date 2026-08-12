require "test_helper"

class DelegatedAccessRequestTest < ActiveSupport::TestCase
  test "creates delegated access request with generated delegation_id and status PENDING_OWNER_APPROVAL" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    req = DelegatedAccessRequest.create!(
      user: user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    assert req.delegation_id.start_with?("del_")
    assert_equal "PENDING_OWNER_APPROVAL", req.status
    assert req.requested_at.present?
  end

  test "approves delegated access request" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    req = DelegatedAccessRequest.create!(
      user: user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    req.approve!
    assert_equal "APPROVED", req.status
    assert_equal "RESIDENT", req.granted_badge
    assert_equal "RESIDENT", req.role
    assert_includes user.reload.badges, "RESIDENT"
  end

  test "rejects delegated access request" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    req = DelegatedAccessRequest.create!(
      user: user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )

    req.reject!
    assert_equal "REJECTED", req.status
  end
end
