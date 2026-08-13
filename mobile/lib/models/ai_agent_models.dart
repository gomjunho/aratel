import 'screen_context.dart';

class ReservationDetails {
  final String facility;
  final int partySize;
  final String status;

  const ReservationDetails({
    required this.facility,
    required this.partySize,
    required this.status,
  });

  factory ReservationDetails.fromJson(Map<String, dynamic> json) {
    return ReservationDetails(
      facility: json['facility'] as String,
      partySize: json['party_size'] as int? ?? 1,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'facility': facility,
        'party_size': partySize,
        'status': status,
      };
}

class AiAgentRequest {
  final String message;

  /// Optional screen context passed to the backend AI so it can give
  /// contextually-aware responses and proactive 1-tap recommendations.
  final ScreenContext? screenContext;

  const AiAgentRequest({required this.message, this.screenContext});

  factory AiAgentRequest.fromJson(Map<String, dynamic> json) {
    return AiAgentRequest(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        if (screenContext != null) 'screen_context': screenContext!.toJson(),
      };
}

class AiAgentResponse {
  final String reply;
  final String actionExecuted;
  final ReservationDetails? reservationDetails;

  const AiAgentResponse({
    required this.reply,
    required this.actionExecuted,
    this.reservationDetails,
  });

  factory AiAgentResponse.fromJson(Map<String, dynamic> json) {
    return AiAgentResponse(
      reply: json['reply'] as String,
      actionExecuted: json['action_executed'] as String? ?? 'NONE',
      reservationDetails: json['reservation_details'] != null
          ? ReservationDetails.fromJson(json['reservation_details'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'reply': reply,
        'action_executed': actionExecuted,
        if (reservationDetails != null) 'reservation_details': reservationDetails!.toJson(),
      };
}
