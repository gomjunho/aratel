require "test_helper"

class ResidentialComplexTest < ActiveSupport::TestCase
  test "valid residential complex with theme colors" do
    complex = ResidentialComplex.new(
      name: "아크로 리버파크",
      primary_color: "#1e3a8a",
      secondary_color: "#0f172a",
      accent_color: "#fbbf24",
      banner_title: "아크로 리버파크 전용 포털",
      description: "한강 조망 프리미엄 포털"
    )
    assert complex.valid?
    assert_kind_of Array, ResidentialComplex.ransackable_attributes
    assert_kind_of Array, ResidentialComplex.ransackable_associations
  end

  test "invalid without name or colors" do
    complex = ResidentialComplex.new
    assert_not complex.valid?
    assert_includes complex.errors[:name], "can't be blank"
    assert_includes complex.errors[:primary_color], "can't be blank"
  end
end
