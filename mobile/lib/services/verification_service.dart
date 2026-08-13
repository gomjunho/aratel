import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/verification_models.dart';

class VerificationService {
  final String baseUrl;
  final http.Client _client;

  VerificationService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? ApiConfig.defaultBaseUrl,
        _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  Future<IdentityVerifyResponse> identityVerify({
    required String name,
    required String phoneNumber,
    required String birthDate,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/identity_verify');
    final request = IdentityVerifyRequest(
      name: name,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
    );

    final response = await _client.post(
      url,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return IdentityVerifyResponse.fromJson(json);
    } else {
      throw Exception('Identity verification failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<TrustApiSyncResponse> trustApiSync({
    required String verificationToken,
    required String complexName,
    required String buildingNumber,
    required String unitNumber,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/verification/trust_api_sync');
    final request = TrustApiSyncRequest(
      verificationToken: verificationToken,
      complexName: complexName,
      buildingNumber: buildingNumber,
      unitNumber: unitNumber,
    );

    final response = await _client.post(
      url,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TrustApiSyncResponse.fromJson(json);
    } else {
      throw Exception('Trust API sync failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<DelegatedAccessResponse> requestDelegatedAccess({
    required String relationship,
    required String documentUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/verification/delegated_access');
    final request = DelegatedAccessRequest(
      relationship: relationship,
      documentUrl: documentUrl,
    );

    final response = await _client.post(
      url,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DelegatedAccessResponse.fromJson(json);
    } else {
      throw Exception('Delegated access request failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<OwnerApprovalResponse> approveDelegatedAccess({
    required String delegationId,
    required bool approved,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/verification/delegated_access/$delegationId/approve');
    final request = OwnerApprovalRequest(approved: approved);

    final response = await _client.post(
      url,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return OwnerApprovalResponse.fromJson(json);
    } else {
      throw Exception('Owner approval failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<TierEvidenceResponse> submitTierEvidence({
    required String evidenceType,
    required String documentUrl,
    String? instagramHandle,
    String? referralCode,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/verification/tier_evidence');
    final request = TierEvidenceRequest(
      evidenceType: evidenceType,
      documentUrl: documentUrl,
      instagramHandle: instagramHandle,
      referralCode: referralCode,
    );

    final response = await _client.post(
      url,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TierEvidenceResponse.fromJson(json);
    } else {
      throw Exception('Tier evidence submission failed with status code ${response.statusCode}: ${response.body}');
    }
  }

  Future<UserTierResponse> getUserTier() async {
    final url = Uri.parse('$baseUrl/api/v1/users/me/tier');

    final response = await _client.get(
      url,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserTierResponse.fromJson(json);
    } else {
      throw Exception('Get user tier failed with status code ${response.statusCode}: ${response.body}');
    }
  }
}
