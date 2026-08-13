import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/ai_agent_models.dart';

class AiAgentService {
  final http.Client client;
  final String baseUrl;

  AiAgentService({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl;

  Future<AiAgentResponse> sendDialogue(AiAgentRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/ai/agent_dialogue'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return AiAgentResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to communicate with AI agent: ${response.statusCode}');
    }
  }
}
