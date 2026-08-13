import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/atelier_models.dart';

class AtelierService {
  final http.Client client;
  final String baseUrl;

  AtelierService({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl;

  Future<FlatMapResponse> getFlatMaps() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/atelier/flat_maps'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return FlatMapResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load flat maps: ${response.statusCode}');
    }
  }

  Future<SimulationResponse> createSimulation(SimulationRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/atelier/simulations'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return SimulationResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to create simulation: ${response.statusCode}');
    }
  }
}
