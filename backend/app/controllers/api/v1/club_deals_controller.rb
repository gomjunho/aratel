module Api
  module V1
    class ClubDealsController < ApplicationController
      skip_before_action :verify_authenticity_token, raise: false

      def index
        deals = ClubDeal.all.map(&:as_api_json)
        render json: { club_deals: deals }, status: :ok
      end

      def order
        deal = ClubDeal.find_by(deal_id: params[:id])
        unless deal
          render json: { status: "error", errors: ["Club deal not found"] }, status: :not_found
          return
        end

        order = ClubDealOrder.new(
          club_deal_id: deal.deal_id,
          used_points: params[:used_points],
          cash_amount: params[:cash_amount]
        )

        if order.save
          render json: order.as_created_json, status: :created
        else
          render json: {
            status: "error",
            errors: order.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
