import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/models/verification_models.dart';
import 'package:aratel_mobile/services/verification_service.dart';

void main() {
  const baseUrl = 'https://api.aratel.com';

  group('VerificationService Unit Tests', () {
    test('identityVerify success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/auth/identity_verify');
        final body = jsonDecode(request.body);
        expect(body['name'], '홍길동');
        expect(body['phone_number'], '01012345678');
        expect(body['birth_date'], '19800101');

        return http.Response(
          jsonEncode({
            'status': 'success',
            'verification_token': 'ver_tok_8f9a2b1c',
            'masked_name': '홍*동',
            'verified_at': '2026-08-13T01:32:00Z',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.identityVerify(
        name: '홍길동',
        phoneNumber: '01012345678',
        birthDate: '19800101',
      );

      expect(res.status, 'success');
      expect(res.verificationToken, 'ver_tok_8f9a2b1c');
      expect(res.maskedName, '홍*동');
      expect(res.verifiedAt, '2026-08-13T01:32:00Z');
    });

    test('identityVerify failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.identityVerify(
          name: '홍길동',
          phoneNumber: '01012345678',
          birthDate: '19800101',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('trustApiSync success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/verification/trust_api_sync');
        final body = jsonDecode(request.body);
        expect(body['verification_token'], 'ver_tok_8f9a2b1c');
        expect(body['complex_name'], '디에이치 방배');
        expect(body['building_number'], '101동');
        expect(body['unit_number'], '1502호');

        return http.Response(
          jsonEncode({
            'status': 'VERIFIED',
            'owner_name_masked': '홍*동',
            'ownership_percentage': 100,
            'badge': 'VERIFIED_OWNER',
            'assigned_tier': 'GOLD',
            'verified_at': '2026-08-13T01:32:05Z',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.trustApiSync(
        verificationToken: 'ver_tok_8f9a2b1c',
        complexName: '디에이치 방배',
        buildingNumber: '101동',
        unitNumber: '1502호',
      );

      expect(res.status, VerificationStatus.verified);
      expect(res.ownerNameMasked, '홍*동');
      expect(res.ownershipPercentage, 100);
      expect(res.badge, BadgeType.verifiedOwner);
      expect(res.assignedTier, MembershipTier.gold);
    });

    test('trustApiSync failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.trustApiSync(
          verificationToken: 'ver_tok_invalid',
          complexName: '디에이치 방배',
          buildingNumber: '101동',
          unitNumber: '1502호',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('requestDelegatedAccess success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/verification/delegated_access');
        final body = jsonDecode(request.body);
        expect(body['relationship'], 'FAMILY');
        expect(body['document_url'], 'https://storage.aratel.com/docs/family_rel_123.pdf');

        return http.Response(
          jsonEncode({
            'delegation_id': 'del_9981',
            'status': 'PENDING_OWNER_APPROVAL',
            'requested_at': '2026-08-13T01:32:10Z',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.requestDelegatedAccess(
        relationship: 'FAMILY',
        documentUrl: 'https://storage.aratel.com/docs/family_rel_123.pdf',
      );

      expect(res.delegationId, 'del_9981');
      expect(res.status, 'PENDING_OWNER_APPROVAL');
    });

    test('requestDelegatedAccess failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.requestDelegatedAccess(
          relationship: 'FAMILY',
          documentUrl: 'invalid_url',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('approveDelegatedAccess success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
            request.url.toString(), '$baseUrl/api/v1/verification/delegated_access/del_9981/approve');
        final body = jsonDecode(request.body);
        expect(body['approved'], true);

        return http.Response(
          jsonEncode({
            'delegation_id': 'del_9981',
            'status': 'APPROVED',
            'granted_badge': 'RESIDENT',
            'role': 'RESIDENT',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.approveDelegatedAccess(
        delegationId: 'del_9981',
        approved: true,
      );

      expect(res.delegationId, 'del_9981');
      expect(res.status, 'APPROVED');
      expect(res.grantedBadge, BadgeType.resident);
      expect(res.role, 'RESIDENT');
    });

    test('approveDelegatedAccess failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.approveDelegatedAccess(
          delegationId: 'del_invalid',
          approved: false,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('submitTierEvidence success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), '$baseUrl/api/v1/verification/tier_evidence');
        final body = jsonDecode(request.body);
        expect(body['evidence_type'], 'INCOME_CERT');
        expect(body['document_url'], 'https://storage.aratel.com/docs/income_2025.pdf');
        expect(body['instagram_handle'], '@vip_user');
        expect(body['referral_code'], 'DIAMOND_777');

        return http.Response(
          jsonEncode({
            'submission_id': 'sub_4412',
            'status': 'UNDER_REVIEW',
            'target_tier': 'DIAMOND',
            'submitted_at': '2026-08-13T01:32:15Z',
          }),
          202,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.submitTierEvidence(
        evidenceType: 'INCOME_CERT',
        documentUrl: 'https://storage.aratel.com/docs/income_2025.pdf',
        instagramHandle: '@vip_user',
        referralCode: 'DIAMOND_777',
      );

      expect(res.submissionId, 'sub_4412');
      expect(res.status, 'UNDER_REVIEW');
      expect(res.targetTier, MembershipTier.diamond);
    });

    test('submitTierEvidence failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unprocessable Entity', 422);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.submitTierEvidence(
          evidenceType: 'INVALID',
          documentUrl: '',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getUserTier success', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$baseUrl/api/v1/users/me/tier');

        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'DIAMOND',
            'badges': ['VERIFIED_OWNER', 'DIAMOND_BLACK'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {
              'screen_capture_prevented': true,
              'privacy_masked': true,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      final res = await service.getUserTier();

      expect(res.userId, 'usr_1001');
      expect(res.tier, MembershipTier.diamond);
      expect(res.badges, [BadgeType.verifiedOwner, BadgeType.diamondBlack]);
      expect(res.complexName, '디에이치 방배');
      expect(res.buildingUnit, '101동 1502호');
      expect(res.securityProfile.screenCapturePrevented, true);
    });

    test('getUserTier failure throws Exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);
      expect(
        () => service.getUserTier(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
