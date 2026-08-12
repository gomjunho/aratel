module Admin
  class VerificationsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @status_filter = params[:status]
      @tier_evidences = TierEvidence.all
      @delegations = DelegatedAccessRequest.all

      if @status_filter.present?
        @tier_evidences = @tier_evidences.where(status: @status_filter)
        @delegations = @delegations.where(status: @status_filter)
      end
    end

    def show
      if params[:type] == "delegation"
        @item = DelegatedAccessRequest.find(params[:id])
        @is_delegation = true
      else
        @item = TierEvidence.find(params[:id])
        @is_delegation = false
      end
    end

    def approve_tier_evidence
      evidence = TierEvidence.find(params[:id])
      evidence.update!(status: "APPROVED", admin_notes: params[:admin_notes])
      evidence.user.update!(tier: evidence.target_tier)
      redirect_to admin_verifications_path, notice: "자산 증빙 서류가 승인되었습니다."
    end

    def reject_tier_evidence
      evidence = TierEvidence.find(params[:id])
      evidence.update!(status: "REJECTED", admin_notes: params[:admin_notes])
      redirect_to admin_verifications_path, alert: "자산 증빙 서류가 반려되었습니다."
    end

    def approve_delegation
      delegation = DelegatedAccessRequest.find(params[:id])
      delegation.update!(status: "APPROVED")
      delegation.user.add_badge("RESIDENT")
      delegation.user.save!
      redirect_to admin_verifications_path, notice: "권한 위임 요청이 승인되었습니다."
    end

    def reject_delegation
      delegation = DelegatedAccessRequest.find(params[:id])
      delegation.update!(status: "REJECTED")
      redirect_to admin_verifications_path, alert: "권한 위임 요청이 거절되었습니다."
    end
  end
end
