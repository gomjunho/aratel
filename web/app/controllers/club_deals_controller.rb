class ClubDealsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_index, :api_order]
  skip_before_action :authenticate_user!, only: [:api_index, :api_order]

  def index
    @club_deals = ClubDeal.all
    if @club_deals.empty?
      @club_deals = [
        ClubDeal.create!(
          deal_id: "deal_552",
          brand: "B&B Italia",
          item_name: "Camaleonda Sofa VVIP Club Deal",
          original_price: 18500000,
          deal_price: 14200000,
          point_discount_limit: 1000000,
          min_participants: 5,
          current_participants: 3,
          status: "OPEN"
        )
      ]
    end
  end

  def show
    @club_deal = ClubDeal.find_by!(deal_id: params[:id])
  end

  def order
    @club_deal = ClubDeal.find_by!(deal_id: params[:id])
    used_points = params[:used_points].to_i
    cash_amount = params[:cash_amount].to_i
    order_id = "ord_#{SecureRandom.random_number(1000..9999)}"

    ClubDealOrder.create!(
      order_id: order_id,
      club_deal_id: @club_deal.deal_id,
      user: current_user,
      used_points: used_points,
      cash_amount: cash_amount,
      status: "ORDER_PLACED",
      remaining_points: 450000
    )

    redirect_to club_deal_path(@club_deal.deal_id), notice: "주문이 성공적으로 접수되었습니다."
  end

  def api_index
    deals = ClubDeal.all
    if deals.empty?
      deals = [
        ClubDeal.create!(
          deal_id: "deal_552",
          brand: "B&B Italia",
          item_name: "Camaleonda Sofa VVIP Club Deal",
          original_price: 18500000,
          deal_price: 14200000,
          point_discount_limit: 1000000,
          min_participants: 5,
          current_participants: 3,
          status: "OPEN"
        )
      ]
    end

    render json: {
      club_deals: deals.map do |d|
        {
          id: d.deal_id,
          brand: d.brand,
          item_name: d.item_name,
          original_price: d.original_price,
          deal_price: d.deal_price,
          point_discount_limit: d.point_discount_limit,
          min_participants: d.min_participants,
          current_participants: d.current_participants,
          status: d.status
        }
      end
    }, status: :ok
  end

  def api_order
    deal_id = params[:id]
    used_points = params[:used_points].to_i
    cash_amount = params[:cash_amount].to_i
    order_id = "ord_#{SecureRandom.random_number(1000..9999)}"

    order = ClubDealOrder.create!(
      order_id: order_id,
      club_deal_id: deal_id,
      user: current_user,
      used_points: used_points,
      cash_amount: cash_amount,
      status: "ORDER_PLACED",
      remaining_points: 450000
    )

    render json: {
      order_id: order.order_id,
      status: order.status,
      remaining_points: order.remaining_points
    }, status: :created
  end
end
