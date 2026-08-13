import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/lounge_models.dart';

class LoungeService {
  final http.Client client;
  final String baseUrl;

  LoungeService({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl;

  Future<LoungePostListResponse> getPosts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/lounge/posts'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return LoungePostListResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load lounge posts: ${response.statusCode}');
    }
  }

  Future<CreatePostResponse> createPost(CreatePostRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/lounge/posts'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return CreatePostResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to create post: ${response.statusCode}');
    }
  }
}
