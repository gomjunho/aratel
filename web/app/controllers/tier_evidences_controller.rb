class TierEvidencesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def new
    @tier_evidence = current_user.tier_evidences.build
  end

  def create
    @tier_evidence = current_user.tier_evidences.build(tier_evidence_params)
    if @tier_evidence.save
      redirect_to verification_path, notice: "VVIP 자산 증빙 서류가 제출되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tier_evidence = TierEvidence.find(params[:id])
  end

  # API Endpoint
  def api_create
    evidence = current_user.tier_evidences.build(
      evidence_type: params[:evidence_type],
      document_url: params[:document_url],
      instagram_handle: params[:instagram_handle],
      referral_code: params[:referral_code],
      target_tier: params[:target_tier] || "DIAMOND"
    )

    if evidence.save
      render json: {
        submission_id: evidence.submission_id,
        status: evidence.status,
        target_tier: evidence.target_tier,
        submitted_at: evidence.submitted_at.iso8601
      }, status: :accepted
    else
      render json: { error: evidence.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def tier_evidence_params
    params.require(:tier_evidence).permit(
      :evidence_type,
      :document_url,
      :instagram_handle,
      :referral_code,
      :target_tier
    )
  end
end
