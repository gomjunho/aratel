module Api
  module V1
    module Verification
      class TierEvidencesController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          te = TierEvidence.new(
            evidence_type: params[:evidence_type],
            document_url: params[:document_url],
            instagram_handle: params[:instagram_handle],
            referral_code: params[:referral_code]
          )

          if te.save
            render json: {
              submission_id: te.submission_id,
              status: te.status,
              target_tier: te.target_tier,
              submitted_at: te.submitted_at.iso8601
            }, status: :accepted
          else
            render json: {
              status: "error",
              errors: te.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
