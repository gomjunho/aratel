import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/club_deal_models.dart';

class ClubDealService {
  final http.Client client;
  final String baseUrl;

  ClubDealService({
    http.Client? client,
    this.baseUrl = 'https://api.aratel.com',
  }) : client = client ?? http.Client();

  Future<ClubDealListResponse> getClubDeals() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/club_deals'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return ClubDealListResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load club deals: ${response.statusCode}');
    }
  }

  Future<ClubDealOrderResponse> placeOrder(String dealId, ClubDealOrderRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/club_deals/$dealId/order'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return ClubDealOrderResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to place order: ${response.statusCode}');
    }
  }
}
