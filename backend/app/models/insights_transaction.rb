class InsightsTransaction
  attr_reader :complex_name

  DEFAULT_COMPLEX = "디에이치 방배"

  def initialize(complex_name: nil)
    @complex_name = complex_name.presence || DEFAULT_COMPLEX
  end

  def transactions
    [
      { floor: 15, price: 2850000000, deal_date: "2026-07-15" },
      { floor: 3, price: 2510000000, deal_date: "2026-07-10" }
    ]
  end

  def supply_gas_index
    {
      risk_level: "LOW",
      upcoming_supply_units: 450,
      analysis_summary: "향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다."
    }
  end

  def as_json(_options = nil)
    {
      complex_name: complex_name,
      transactions: transactions,
      supply_gas_index: supply_gas_index
    }
  end
end
