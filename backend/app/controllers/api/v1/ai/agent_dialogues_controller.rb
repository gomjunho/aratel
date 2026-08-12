module Api
  module V1
    module Ai
      class AgentDialoguesController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          dialogue = AgentDialogue.new(message: params[:message])
          result = dialogue.process

          if result[:action_executed] == "NONE" && params[:message].to_s.strip.blank?
            render json: result, status: :unprocessable_entity
          else
            render json: result, status: :ok
          end
        end
      end
    end
  end
end
