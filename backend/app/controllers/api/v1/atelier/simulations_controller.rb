module Api
  module V1
    module Atelier
      class SimulationsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          sim = AtelierSimulation.new(
            flat_map_id: params[:flat_map_id],
            placed_items: params[:placed_items].is_a?(Array) ? params[:placed_items].to_json : params[:placed_items]
          )

          if sim.save
            render json: sim.as_created_json, status: :created
          else
            render json: {
              status: "error",
              errors: sim.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
