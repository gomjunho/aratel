require "test_helper"

class InsightsTransactionTest < ActiveSupport::TestCase
  test "as_json returns transactions and supply gas index" do
    insight = InsightsTransaction.new(complex_name: "디에이치 방배")
    json = insight.as_json

    assert_equal "디에이치 방배", json[:complex_name]
    assert_kind_of Array, json[:transactions]
    assert_equal 2, json[:transactions].length

    t1 = json[:transactions].first
    assert_equal 15, t1[:floor]
    assert_equal 2850000000, t1[:price]
    assert_equal "2026-07-15", t1[:deal_date]

    assert_kind_of Hash, json[:supply_gas_index]
    assert_equal "LOW", json[:supply_gas_index][:risk_level]
    assert_equal 450, json[:supply_gas_index][:upcoming_supply_units]
    assert_equal "향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다.", json[:supply_gas_index][:analysis_summary]
  end

  test "default complex_name if blank" do
    insight = InsightsTransaction.new(complex_name: nil)
    assert_equal "디에이치 방배", insight.complex_name
  end
end
