import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/insights_models.dart';

class InsightsService {
  final http.Client client;
  final String baseUrl;

  InsightsService({
    http.Client? client,
    this.baseUrl = 'https://api.aratel.com',
  }) : client = client ?? http.Client();

  Future<InsightsResponse> getInsights() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/insights/transactions'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return InsightsResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load insights transactions: ${response.statusCode}');
    }
  }
}
