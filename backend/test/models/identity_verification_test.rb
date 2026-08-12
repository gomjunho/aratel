require "test_helper"

class IdentityVerificationTest < ActiveSupport::TestCase
  test "valid identity verification auto-generates token and masked name" do
    iv = IdentityVerification.new(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101"
    )
    assert iv.valid?
    assert iv.verification_token.start_with?("ver_tok_")
    assert_equal "홍*동", iv.masked_name
    assert_equal "success", iv.status
    assert_not_nil iv.verified_at
  end

  test "requires name, phone_number, and birth_date" do
    iv = IdentityVerification.new
    assert_not iv.valid?
    assert_includes iv.errors[:name], "can't be blank"
    assert_includes iv.errors[:phone_number], "can't be blank"
    assert_includes iv.errors[:birth_date], "can't be blank"
  end
end
