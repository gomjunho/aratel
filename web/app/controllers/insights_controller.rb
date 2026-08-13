class InsightsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_transactions]
  skip_before_action :authenticate_user!, only: [:api_transactions]

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

    @urgent_deals = [
      { unit: "101동 1803호 (84A타입)", market_price: 2650000000, urgent_price: 2420000000, discount: "2.3억원 (9%)", reason: "해외 이주로 인한 긴급 분양권/소유권 처분" },
      { unit: "103동 2201호 (114B타입)", market_price: 3600000000, urgent_price: 3350000000, discount: "2.5억원 (7%)", reason: "상속세 납부용 기한 한정 긴급 매각" }
    ]

    @wealth_news = [
      { tag: "트렌드", title: "2026 하반기 강남 3구 펜트하우스 희소성 상승 분석", date: "2026-08-12", summary: "금리 인하 기조와 맞물려 하이엔드 아파트 신규 분양 물량 희귀 현상 지속" },
      { tag: "절세 노하우", title: "법인 명의 고가 주택 보유세 및 종합부동산세 개정 가이드", date: "2026-08-10", summary: "증여세 한도 이월 및 가족 법인 자산 승계 통합 절세 패키지 전략" }
    ]

    @investment_proposals = [
      { category: "토지/개발", title: "강남대로 메디컬 빌딩 지분형 펀드 투자", expected_yield: "연 8.5%", min_investment: "5,000만원", status: "VVIP 모집중" },
      { category: "해외 부동산", title: "도쿄 롯폰기 하이엔드 레지던스 사전 분양", expected_yield: "연 6.8% (엔화 자산)", min_investment: "1억원", status: "마감 임박" }
    ]
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
      supply_gas_index: @supply_gas_index,
      urgent_deals: @urgent_deals,
      wealth_news: @wealth_news,
      investment_proposals: @investment_proposals
    }, status: :ok
  end
end
