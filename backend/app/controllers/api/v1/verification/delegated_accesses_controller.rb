module Api
  module V1
    module Verification
      class DelegatedAccessesController < ApplicationController
        def create
          da = DelegatedAccess.new(delegated_params)

          if da.save
            render json: {
              delegation_id: da.delegation_id,
              status: da.status,
              requested_at: da.requested_at.iso8601
            }, status: :created
          else
            render json: {
              status: "error",
              errors: da.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def approve
          da = DelegatedAccess.find_by(delegation_id: params[:id])
          unless da
            render json: { status: "error", message: "Delegated access request not found" }, status: :not_found
            return
          end

          approved = ActiveModel::Type::Boolean.new.cast(params[:approved])
          da.approve!(approved)

          render json: {
            delegation_id: da.delegation_id,
            status: da.status,
            granted_badge: da.granted_badge,
            role: da.role
          }, status: :ok
        end

        private

        def delegated_params
          params.permit(:relationship, :document_url)
        end
      end
    end
  end
end
