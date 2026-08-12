module Api
  module V1
    module Auth
      class IdentityVerificationsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false

        def create
          iv = IdentityVerification.new(
            name: params[:name],
            phone_number: params[:phone_number],
            birth_date: params[:birth_date]
          )

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
      end
    end
  end
end
