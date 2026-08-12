class ConciergeReservationRequest {
  final String serviceType;
  final String preferredDate;
  final String? notes;

  const ConciergeReservationRequest({
    required this.serviceType,
    required this.preferredDate,
    this.notes,
  });

  factory ConciergeReservationRequest.fromJson(Map<String, dynamic> json) {
    return ConciergeReservationRequest(
      serviceType: json['service_type'] as String,
      preferredDate: json['preferred_date'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'service_type': serviceType,
        'preferred_date': preferredDate,
        if (notes != null) 'notes': notes,
      };
}

class ConciergeReservationResponse {
  final String reservationId;
  final String serviceType;
  final String status;
  final String assignedConsultant;

  const ConciergeReservationResponse({
    required this.reservationId,
    required this.serviceType,
    required this.status,
    required this.assignedConsultant,
  });

  factory ConciergeReservationResponse.fromJson(Map<String, dynamic> json) {
    return ConciergeReservationResponse(
      reservationId: json['reservation_id'] as String,
      serviceType: json['service_type'] as String,
      status: json['status'] as String,
      assignedConsultant: json['assigned_consultant'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'reservation_id': reservationId,
        'service_type': serviceType,
        'status': status,
        'assigned_consultant': assignedConsultant,
      };
}
