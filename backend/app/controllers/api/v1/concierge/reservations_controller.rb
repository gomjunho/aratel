module Api
  module V1
    module Concierge
      class ReservationsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          res = ConciergeReservation.new(
            service_type: params[:service_type],
            preferred_date: params[:preferred_date],
            notes: params[:notes]
          )

          if res.save
            render json: res.as_created_json, status: :created
          else
            render json: {
              status: "error",
              errors: res.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
