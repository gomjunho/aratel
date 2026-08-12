module Api
  module V1
    module Verification
      class TrustApiSyncsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          iv = IdentityVerification.find_by(verification_token: params[:verification_token])
          unless iv
            render json: { status: "error", message: "Invalid verification token" }, status: :unprocessable_entity
            return
          end

          sync = TrustApiSync.new(
            verification_token: params[:verification_token],
            complex_name: params[:complex_name],
            building_number: params[:building_number],
            unit_number: params[:unit_number],
            owner_name_masked: iv.masked_name
          )

          if sync.save
            render json: {
              status: sync.status,
              owner_name_masked: sync.owner_name_masked,
              ownership_percentage: sync.ownership_percentage,
              badge: sync.badge,
              assigned_tier: sync.assigned_tier,
              verified_at: sync.verified_at.iso8601
            }, status: :ok
          else
            render json: {
              status: "error",
              errors: sync.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
