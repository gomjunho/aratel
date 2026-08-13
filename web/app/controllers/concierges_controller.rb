class ConciergesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create_reservation]
  skip_before_action :authenticate_user!, only: [:api_create_reservation]

  def show
    @reservations = ConciergeReservation.where(user: current_user).order(created_at: :desc)
    @concierge_reservation = ConciergeReservation.new
  end

  def create
    res_params = params.require(:concierge_reservation).permit(:service_type, :preferred_date, :notes)
    service_type = res_params[:service_type]
    consultant = service_type == "WOORI_TWO_CHAIRS" ? "우리은행 TWO CHAIRS 수석 자산관리사" : "ARATEL VIP 전담 컨시어지"

    ConciergeReservation.create!(
      reservation_id: "res_#{SecureRandom.random_number(1000..9999)}",
      user: current_user,
      service_type: service_type,
      preferred_date: res_params[:preferred_date],
      notes: res_params[:notes],
      status: "CONFIRMED",
      assigned_consultant: consultant
    )

    redirect_to concierge_path, notice: "VIP 컨시어지 예약이 완료되었습니다."
  end

  def api_create_reservation
    service_type = params[:service_type]
    preferred_date = params[:preferred_date]
    notes = params[:notes]
    consultant = service_type == "WOORI_TWO_CHAIRS" ? "우리은행 TWO CHAIRS 수석 자산관리사" : "ARATEL VIP 전담 컨시어지"

    res = ConciergeReservation.create!(
      reservation_id: "res_#{SecureRandom.random_number(1000..9999)}",
      user: current_user,
      service_type: service_type,
      preferred_date: preferred_date,
      notes: notes,
      status: "CONFIRMED",
      assigned_consultant: consultant
    )

    render json: {
      reservation_id: res.reservation_id,
      service_type: res.service_type,
      status: res.status,
      assigned_consultant: res.assigned_consultant
    }, status: :created
  end
end
