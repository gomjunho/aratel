require "test_helper"

class Api::V1::Insights::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/insights/transactions returns transaction data and supply gas index" do
    get "/api/v1/insights/transactions"

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "디에이치 방배", json["complex_name"]
    assert_kind_of Array, json["transactions"]
    assert_equal 2, json["transactions"].length
    assert_equal 15, json["transactions"].first["floor"]
    assert_equal 2850000000, json["transactions"].first["price"]
    assert_equal "2026-07-15", json["transactions"].first["deal_date"]

    assert_equal "LOW", json["supply_gas_index"]["risk_level"]
    assert_equal 450, json["supply_gas_index"]["upcoming_supply_units"]
    assert_equal "향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다.", json["supply_gas_index"]["analysis_summary"]
  end
end
