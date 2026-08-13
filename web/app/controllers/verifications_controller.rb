class VerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [
    :api_identity_verify,
    :api_trust_api_sync,
    :api_me_tier
  ]
  skip_before_action :authenticate_user!, only: [
    :api_identity_verify,
    :api_trust_api_sync,
    :api_me_tier
  ]

  def show
    @user = current_user
    @delegated_access_requests = @user.delegated_access_requests.order(created_at: :desc)
    @tier_evidences = @user.tier_evidences.order(created_at: :desc)
  end

  def identity_verify
    user = current_user
    user.update!(
      name: params[:name] || user.name,
      phone_number: params[:phone_number] || user.phone_number,
      birth_date: params[:birth_date] || user.birth_date
    )
    user.verify_identity!
    redirect_to verification_path, notice: "휴대폰 본인확인이 완료되었습니다."
  end

  def trust_api_sync
    user = current_user
    user.sync_trust_api!(
      complex_name: params[:complex_name],
      building_number: params[:building_number],
      unit_number: params[:unit_number]
    )
    redirect_to verification_path, notice: "1분 자동 등기부 연동이 완료되었습니다."
  end

  # API Endpoints per Epic 1 Contract
  def api_identity_verify
    user = current_user
    user.update!(
      name: params[:name] || user.name,
      phone_number: params[:phone_number] || user.phone_number,
      birth_date: params[:birth_date] || user.birth_date
    )
    user.verify_identity!

    render json: {
      status: "success",
      verification_token: user.verification_token,
      masked_name: user.masked_name,
      verified_at: user.verified_identity_at&.iso8601
    }, status: :ok
  end

  def api_trust_api_sync
    user = current_user
    user.sync_trust_api!(
      complex_name: params[:complex_name],
      building_number: params[:building_number],
      unit_number: params[:unit_number]
    )

    render json: {
      status: "VERIFIED",
      owner_name_masked: user.masked_name,
      ownership_percentage: user.ownership_percentage,
      badge: user.badge,
      assigned_tier: user.tier,
      verified_at: Time.current.iso8601
    }, status: :ok
  end

  def api_me_tier
    user = current_user
    building_unit = [user.building_number, user.unit_number].compact.join(" ")
    building_unit = nil if building_unit.blank?

    render json: {
      user_id: "usr_#{user.id}",
      tier: user.tier,
      badges: user.badges,
      complex_name: user.complex_name,
      building_unit: building_unit,
      security_profile: user.security_profile
    }, status: :ok
  end
end
