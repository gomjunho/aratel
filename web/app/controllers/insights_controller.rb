class InsightsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_transactions]

  def show
    @complex_name = current_user.complex_name.presence || "디에이치 방배"
    @transactions = RealEstateTransaction.where(complex_name: @complex_name).order(deal_date: :desc)
    if @transactions.empty?
      @transactions = [
        RealEstateTransaction.create!(complex_name: @complex_name, floor: 15, price: 2850000000, deal_date: "2026-07-15"),
        RealEstateTransaction.create!(complex_name: @complex_name, floor: 3, price: 2510000000, deal_date: "2026-07-10")
      ]
    end

    @supply_gas_index = {
      risk_level: "LOW",
      upcoming_supply_units: 450,
      analysis_summary: "향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다."
    }
  end

  def api_transactions
    show
    render json: {
      complex_name: @complex_name,
      transactions: @transactions.map do |tx|
        {
          floor: tx.floor,
          price: tx.price,
          deal_date: tx.deal_date
        }
      end,
      supply_gas_index: @supply_gas_index
    }, status: :ok
  end
end
