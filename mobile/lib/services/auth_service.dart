import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthUser {
  final String userId;
  final String name;
  final String tier;
  final String token;

  AuthUser({
    required this.userId,
    required this.name,
    required this.tier,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '소유주',
      tier: json['tier'] ?? 'BRONZE',
      token: json['token'] ?? '',
    );
  }
}

class AuthService {
  final http.Client client;
  static String? _authToken;
  static AuthUser? _currentUser;

  AuthService({http.Client? client}) : client = client ?? http.Client();

  static String? get authToken => _authToken;
  static AuthUser? get currentUser => _currentUser;
  static bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static void clearAuthToken() {
    _authToken = null;
    _currentUser = null;
  }

  static Map<String, String> get authHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<AuthUser> login(String userId, String password) async {
    final uri = Uri.parse('${ApiConfig.defaultBaseUrl}/api/v1/auth/login');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = AuthUser.fromJson(data);
      _authToken = user.token;
      _currentUser = user;
      return user;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? '로그인에 실패했습니다.');
    }
  }

  Future<AuthUser> register(String email, String password, String name) async {
    final uri = Uri.parse('${ApiConfig.defaultBaseUrl}/api/v1/auth/register');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final user = AuthUser.fromJson(data);
      _authToken = user.token;
      _currentUser = user;
      return user;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? '회원가입에 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final uri = Uri.parse('${ApiConfig.defaultBaseUrl}/api/v1/auth/me');
    final response = await client.get(
      uri,
      headers: authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('프로필 정보를 불러올 수 없습니다.');
    }
  }
}
