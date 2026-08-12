module Admin
  class VerificationsController < ApplicationController
    def index
      @status = params[:status]
      @tier_evidences = TierEvidence.includes(:user).order(created_at: :desc)
      @delegations = DelegatedAccessRequest.includes(:user).order(created_at: :desc)

      if @status.present?
        @tier_evidences = @tier_evidences.where(status: @status)
        @delegations = @delegations.where(status: @status)
      end
    end

    def show
      @tier_evidence = TierEvidence.find_by(id: params[:id])
      @delegation = DelegatedAccessRequest.find_by(id: params[:id]) unless @tier_evidence
    end

    def approve_tier_evidence
      evidence = TierEvidence.find(params[:id])
      evidence.approve!(admin_notes: params[:admin_notes])
      redirect_to admin_verifications_path, notice: "자산 증빙 서류가 승인되었습니다."
    end

    def reject_tier_evidence
      evidence = TierEvidence.find(params[:id])
      evidence.reject!(admin_notes: params[:admin_notes])
      redirect_to admin_verifications_path, alert: "자산 증빙 서류가 반려되었습니다."
    end

    def approve_delegation
      delegation = DelegatedAccessRequest.find(params[:id])
      delegation.approve!
      redirect_to admin_verifications_path, notice: "권한 위임 요청이 승인되었습니다."
    end

    def reject_delegation
      delegation = DelegatedAccessRequest.find(params[:id])
      delegation.reject!
      redirect_to admin_verifications_path, alert: "권한 위임 요청이 거절되었습니다."
    end
  end
end
