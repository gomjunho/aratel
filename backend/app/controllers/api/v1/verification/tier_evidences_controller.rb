module Api
  module V1
    module Verification
      class TierEvidencesController < ApplicationController
        def create
          te = TierEvidence.new(evidence_params)

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

        private

        def evidence_params
          params.permit(:evidence_type, :document_url, :instagram_handle, :referral_code)
        end
      end
    end
  end
end
