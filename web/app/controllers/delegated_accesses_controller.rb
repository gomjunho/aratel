class DelegatedAccessesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create, :api_approve]
  skip_before_action :authenticate_user!, only: [:api_create, :api_approve]

  def create
    req = current_user.delegated_access_requests.build(delegated_access_params)
    if req.save
      redirect_to verification_path, notice: "대리인/가족 권한 위임 신청이 완료되었습니다."
    else
      redirect_to verification_path, alert: "위임 신청 중 오류가 발생했습니다."
    end
  end

  def approve
    req = DelegatedAccessRequest.find(params[:id])
    if params[:approved] == "false" || params[:approved] == false
      req.reject!
      redirect_to verification_path, alert: "위임 신청이 거절되었습니다."
    else
      req.approve!
      redirect_to verification_path, notice: "위임 신청이 승인되었습니다."
    end
  end

  # API Endpoints
  def api_create
    req = current_user.delegated_access_requests.build(
      relationship: params[:relationship],
      document_url: params[:document_url]
    )
    if req.save
      render json: {
        delegation_id: req.delegation_id,
        status: req.status,
        requested_at: req.requested_at.iso8601
      }, status: :created
    else
      render json: { error: req.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def api_approve
    req = DelegatedAccessRequest.find_by(id: params[:id]) || DelegatedAccessRequest.find_by!(delegation_id: params[:id])
    if params[:approved] == false || params[:approved] == "false"
      req.reject!
      render json: {
        delegation_id: req.delegation_id,
        status: "REJECTED"
      }, status: :ok
    else
      req.approve!
      render json: {
        delegation_id: req.delegation_id,
        status: req.status,
        granted_badge: req.granted_badge,
        role: req.role
      }, status: :ok
    end
  end

  private

  def delegated_access_params
    params.require(:delegated_access).permit(:relationship, :document_url)
  end
end
