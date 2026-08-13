import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/concierge_models.dart';

class ConciergeService {
  final http.Client client;
  final String baseUrl;

  ConciergeService({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl;

  Future<ConciergeReservationResponse> createReservation(ConciergeReservationRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/concierge/reservations'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return ConciergeReservationResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to create concierge reservation: ${response.statusCode}');
    }
  }
}
