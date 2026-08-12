require "test_helper"

class TierEvidenceTest < ActiveSupport::TestCase
  test "valid tier evidence auto-generates submission_id and default attributes" do
    te = TierEvidence.new(
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      instagram_handle: "@vip_user",
      referral_code: "DIAMOND_777"
    )
    assert te.valid?
    assert te.submission_id.start_with?("sub_")
    assert_equal "UNDER_REVIEW", te.status
    assert_equal "DIAMOND", te.target_tier
    assert_not_nil te.submitted_at
  end

  test "requires evidence_type and document_url" do
    te = TierEvidence.new
    assert_not te.valid?
    assert_includes te.errors[:evidence_type], "can't be blank"
    assert_includes te.errors[:document_url], "can't be blank"
  end
end
