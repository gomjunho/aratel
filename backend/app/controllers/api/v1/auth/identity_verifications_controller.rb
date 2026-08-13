module Api
  module V1
    module Auth
      class IdentityVerificationsController < ApplicationController
        def create
          iv = IdentityVerification.new(verification_params)

          if iv.save
            render json: {
              status: "success",
              verification_token: iv.verification_token,
              masked_name: iv.masked_name,
              verified_at: iv.verified_at.iso8601
            }, status: :ok
          else
            render json: {
              status: "error",
              errors: iv.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        private

        def verification_params
          params.permit(:name, :phone_number, :birth_date)
        end
      end
    end
  end
end
