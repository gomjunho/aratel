module Api
  module V1
    module Concierge
      class ReservationsController < ApplicationController
        def create
          res = ConciergeReservation.new(reservation_params)

          if res.save
            render json: res.as_created_json, status: :created
          else
            render json: {
              status: "error",
              errors: res.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def reservation_params
          params.permit(:service_type, :preferred_date, :notes)
        end
      end
    end
  end
end
