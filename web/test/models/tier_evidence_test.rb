require "test_helper"

class TierEvidenceTest < ActiveSupport::TestCase
  test "creates tier evidence with generated submission_id and default UNDER_REVIEW status" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    evidence = TierEvidence.create!(
      user: user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      instagram_handle: "@vip_user",
      referral_code: "DIAMOND_777",
      target_tier: "DIAMOND"
    )

    assert evidence.submission_id.start_with?("sub_")
    assert_equal "UNDER_REVIEW", evidence.status
    assert_equal "DIAMOND", evidence.target_tier
    assert evidence.submitted_at.present?
  end

  test "approves tier evidence and upgrades user tier and badges" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    evidence = TierEvidence.create!(
      user: user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      target_tier: "DIAMOND"
    )

    evidence.approve!(admin_notes: "Asset verified successfully")
    assert_equal "VERIFIED", evidence.status
    assert evidence.reviewed_at.present?
    assert_equal "Asset verified successfully", evidence.admin_notes
    assert_equal "DIAMOND", user.reload.tier
    assert_includes user.badges, "DIAMOND_BLACK"

    # Test PLATINUM tier
    ev_plat = TierEvidence.create!(user: user, evidence_type: "BALANCE_CERT", document_url: "url", target_tier: "PLATINUM")
    ev_plat.approve!
    assert_equal "PLATINUM", user.reload.tier
    assert_includes user.badges, "PLATINUM_SILVER"

    # Test GOLD tier
    ev_gold = TierEvidence.create!(user: user, evidence_type: "DEED", document_url: "url", target_tier: "GOLD")
    ev_gold.approve!
    assert_equal "GOLD", user.reload.tier
    assert_includes user.badges, "GOLD_EMBLEM"

    # Test BRONZE tier fallback
    ev_bronze = TierEvidence.create!(user: user, evidence_type: "OTHER", document_url: "url", target_tier: "BRONZE")
    ev_bronze.approve!
    assert_equal "BRONZE", user.reload.tier
    assert_includes user.badges, "BRONZE_METALLIC"
  end

  test "rejects tier evidence" do
    user = User.create!(name: "홍길동", phone_number: "01012345678", birth_date: "19800101")
    evidence = TierEvidence.create!(
      user: user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf"
    )

    evidence.reject!(admin_notes: "Insufficient income documentation")
    assert_equal "REJECTED", evidence.status
    assert evidence.reviewed_at.present?
    assert_equal "Insufficient income documentation", evidence.admin_notes
  end
end
