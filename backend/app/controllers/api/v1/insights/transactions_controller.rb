module Api
  module V1
    module Insights
      class TransactionsController < ApplicationController
        def index
          insight = InsightsTransaction.new(complex_name: params[:complex_name])
          render json: insight.as_json, status: :ok
        end
      end
    end
  end
end
