module Api
  module V1
    module Atelier
      class SimulationsController < ApplicationController
        def create
          s_params = simulation_params
          placed = s_params[:placed_items]

          sim = AtelierSimulation.new(
            flat_map_id: s_params[:flat_map_id],
            placed_items: placed.is_a?(Array) || placed.is_a?(ActionController::Parameters) ? placed.to_json : placed
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

        private

        def simulation_params
          params.permit(:flat_map_id, placed_items: [:furniture_id, position: [], rotation: []])
        end
      end
    end
  end
end
