require "test_helper"

class DelegatedAccessTest < ActiveSupport::TestCase
  test "valid delegated access auto-generates delegation_id and status" do
    da = DelegatedAccess.new(
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )
    assert da.valid?
    assert da.delegation_id.start_with?("del_")
    assert_equal "PENDING_OWNER_APPROVAL", da.status
    assert_not_nil da.requested_at
  end

  test "requires relationship and document_url" do
    da = DelegatedAccess.new
    assert_not da.valid?
    assert_includes da.errors[:relationship], "can't be blank"
    assert_includes da.errors[:document_url], "can't be blank"
  end

  test "approve! updates status and granted_badge when true" do
    da = DelegatedAccess.create!(
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )
    da.approve!(true)
    assert_equal "APPROVED", da.status
    assert_equal "RESIDENT", da.granted_badge
    assert_equal "RESIDENT", da.role
  end

  test "approve! updates status to REJECTED when false" do
    da = DelegatedAccess.create!(
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )
    da.approve!(false)
    assert_equal "REJECTED", da.status
    assert_nil da.granted_badge
    assert_nil da.role
  end
end
