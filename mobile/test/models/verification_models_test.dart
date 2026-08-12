import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/verification_models.dart';

void main() {
  group('Verification Enums', () {
    test('MembershipTier conversion', () {
      expect(MembershipTier.fromString('DIAMOND'), MembershipTier.diamond);
      expect(MembershipTier.fromString('PLATINUM'), MembershipTier.platinum);
      expect(MembershipTier.fromString('GOLD'), MembershipTier.gold);
      expect(MembershipTier.fromString('BRONZE'), MembershipTier.bronze);
      expect(MembershipTier.fromString('UNKNOWN'), MembershipTier.bronze);

      expect(MembershipTier.diamond.toValue(), 'DIAMOND');
      expect(MembershipTier.platinum.toValue(), 'PLATINUM');
      expect(MembershipTier.gold.toValue(), 'GOLD');
      expect(MembershipTier.bronze.toValue(), 'BRONZE');
    });

    test('BadgeType conversion', () {
      expect(BadgeType.fromString('VERIFIED_OWNER'), BadgeType.verifiedOwner);
      expect(BadgeType.fromString('RESIDENT'), BadgeType.resident);
      expect(BadgeType.fromString('DIAMOND_BLACK'), BadgeType.diamondBlack);
      expect(BadgeType.fromString('PLATINUM_SILVER'), BadgeType.platinumSilver);
      expect(BadgeType.fromString('GOLD_EMBLEM'), BadgeType.goldEmblem);
      expect(BadgeType.fromString('BRONZE_METALLIC'), BadgeType.bronzeMetallic);
      expect(BadgeType.fromString('UNKNOWN'), BadgeType.verifiedOwner);

      expect(BadgeType.verifiedOwner.toValue(), 'VERIFIED_OWNER');
      expect(BadgeType.resident.toValue(), 'RESIDENT');
      expect(BadgeType.diamondBlack.toValue(), 'DIAMOND_BLACK');
      expect(BadgeType.platinumSilver.toValue(), 'PLATINUM_SILVER');
      expect(BadgeType.goldEmblem.toValue(), 'GOLD_EMBLEM');
      expect(BadgeType.bronzeMetallic.toValue(), 'BRONZE_METALLIC');
    });

    test('VerificationStatus conversion', () {
      expect(VerificationStatus.fromString('UNVERIFIED'), VerificationStatus.unverified);
      expect(VerificationStatus.fromString('PENDING'), VerificationStatus.pending);
      expect(VerificationStatus.fromString('VERIFIED'), VerificationStatus.verified);
      expect(VerificationStatus.fromString('REJECTED'), VerificationStatus.rejected);
      expect(VerificationStatus.fromString('UNKNOWN'), VerificationStatus.unverified);

      expect(VerificationStatus.unverified.toValue(), 'UNVERIFIED');
      expect(VerificationStatus.pending.toValue(), 'PENDING');
      expect(VerificationStatus.verified.toValue(), 'VERIFIED');
      expect(VerificationStatus.rejected.toValue(), 'REJECTED');
    });
  });

  group('IdentityVerify Models', () {
    test('IdentityVerifyRequest toJson and fromJson', () {
      const request = IdentityVerifyRequest(
        name: '홍길동',
        phoneNumber: '01012345678',
        birthDate: '19800101',
      );
      final json = request.toJson();
      expect(json['name'], '홍길동');
      expect(json['phone_number'], '01012345678');
      expect(json['birth_date'], '19800101');

      final parsed = IdentityVerifyRequest.fromJson(json);
      expect(parsed.name, request.name);
      expect(parsed.phoneNumber, request.phoneNumber);
      expect(parsed.birthDate, request.birthDate);
    });

    test('IdentityVerifyResponse fromJson and toJson', () {
      final json = {
        'status': 'success',
        'verification_token': 'ver_tok_8f9a2b1c',
        'masked_name': '홍*동',
        'verified_at': '2026-08-13T01:32:00Z',
      };
      final response = IdentityVerifyResponse.fromJson(json);
      expect(response.status, 'success');
      expect(response.verificationToken, 'ver_tok_8f9a2b1c');
      expect(response.maskedName, '홍*동');
      expect(response.verifiedAt, '2026-08-13T01:32:00Z');

      expect(response.toJson(), json);
    });
  });

  group('TrustApiSync Models', () {
    test('TrustApiSyncRequest toJson and fromJson', () {
      const request = TrustApiSyncRequest(
        verificationToken: 'ver_tok_8f9a2b1c',
        complexName: '디에이치 방배',
        buildingNumber: '101동',
        unitNumber: '1502호',
      );
      final json = request.toJson();
      expect(json['verification_token'], 'ver_tok_8f9a2b1c');
      expect(json['complex_name'], '디에이치 방배');
      expect(json['building_number'], '101동');
      expect(json['unit_number'], '1502호');

      final parsed = TrustApiSyncRequest.fromJson(json);
      expect(parsed.verificationToken, request.verificationToken);
      expect(parsed.complexName, request.complexName);
      expect(parsed.buildingNumber, request.buildingNumber);
      expect(parsed.unitNumber, request.unitNumber);
    });

    test('TrustApiSyncResponse fromJson and toJson', () {
      final json = {
        'status': 'VERIFIED',
        'owner_name_masked': '홍*동',
        'ownership_percentage': 100,
        'badge': 'VERIFIED_OWNER',
        'assigned_tier': 'GOLD',
        'verified_at': '2026-08-13T01:32:05Z',
      };
      final response = TrustApiSyncResponse.fromJson(json);
      expect(response.status, VerificationStatus.verified);
      expect(response.ownerNameMasked, '홍*동');
      expect(response.ownershipPercentage, 100);
      expect(response.badge, BadgeType.verifiedOwner);
      expect(response.assignedTier, MembershipTier.gold);
      expect(response.verifiedAt, '2026-08-13T01:32:05Z');

      expect(response.toJson(), json);
    });
  });

  group('DelegatedAccess Models', () {
    test('DelegatedAccessRequest toJson and fromJson', () {
      const request = DelegatedAccessRequest(
        relationship: 'FAMILY',
        documentUrl: 'https://storage.aratel.com/docs/family_rel_123.pdf',
      );
      final json = request.toJson();
      expect(json['relationship'], 'FAMILY');
      expect(json['document_url'], 'https://storage.aratel.com/docs/family_rel_123.pdf');

      final parsed = DelegatedAccessRequest.fromJson(json);
      expect(parsed.relationship, request.relationship);
      expect(parsed.documentUrl, request.documentUrl);
    });

    test('DelegatedAccessResponse fromJson and toJson', () {
      final json = {
        'delegation_id': 'del_9981',
        'status': 'PENDING_OWNER_APPROVAL',
        'requested_at': '2026-08-13T01:32:10Z',
      };
      final response = DelegatedAccessResponse.fromJson(json);
      expect(response.delegationId, 'del_9981');
      expect(response.status, 'PENDING_OWNER_APPROVAL');
      expect(response.requestedAt, '2026-08-13T01:32:10Z');

      expect(response.toJson(), json);
    });

    test('OwnerApprovalRequest toJson and fromJson', () {
      const request = OwnerApprovalRequest(approved: true);
      final json = request.toJson();
      expect(json['approved'], true);

      final parsed = OwnerApprovalRequest.fromJson(json);
      expect(parsed.approved, true);
    });

    test('OwnerApprovalResponse fromJson and toJson', () {
      final json = {
        'delegation_id': 'del_9981',
        'status': 'APPROVED',
        'granted_badge': 'RESIDENT',
        'role': 'RESIDENT',
      };
      final response = OwnerApprovalResponse.fromJson(json);
      expect(response.delegationId, 'del_9981');
      expect(response.status, 'APPROVED');
      expect(response.grantedBadge, BadgeType.resident);
      expect(response.role, 'RESIDENT');

      expect(response.toJson(), json);
    });
  });

  group('TierEvidence Models', () {
    test('TierEvidenceRequest toJson and fromJson', () {
      const request = TierEvidenceRequest(
        evidenceType: 'INCOME_CERT',
        documentUrl: 'https://storage.aratel.com/docs/income_2025.pdf',
        instagramHandle: '@vip_user',
        referralCode: 'DIAMOND_777',
      );
      final json = request.toJson();
      expect(json['evidence_type'], 'INCOME_CERT');
      expect(json['document_url'], 'https://storage.aratel.com/docs/income_2025.pdf');
      expect(json['instagram_handle'], '@vip_user');
      expect(json['referral_code'], 'DIAMOND_777');

      final parsed = TierEvidenceRequest.fromJson(json);
      expect(parsed.evidenceType, request.evidenceType);
      expect(parsed.documentUrl, request.documentUrl);
      expect(parsed.instagramHandle, request.instagramHandle);
      expect(parsed.referralCode, request.referralCode);
    });

    test('TierEvidenceResponse fromJson and toJson', () {
      final json = {
        'submission_id': 'sub_4412',
        'status': 'UNDER_REVIEW',
        'target_tier': 'DIAMOND',
        'submitted_at': '2026-08-13T01:32:15Z',
      };
      final response = TierEvidenceResponse.fromJson(json);
      expect(response.submissionId, 'sub_4412');
      expect(response.status, 'UNDER_REVIEW');
      expect(response.targetTier, MembershipTier.diamond);
      expect(response.submittedAt, '2026-08-13T01:32:15Z');

      expect(response.toJson(), json);
    });
  });

  group('UserTier & Security Profile Models', () {
    test('SecurityProfile fromJson and toJson', () {
      final json = {
        'screen_capture_prevented': true,
        'privacy_masked': true,
      };
      final profile = SecurityProfile.fromJson(json);
      expect(profile.screenCapturePrevented, true);
      expect(profile.privacyMasked, true);
      expect(profile.toJson(), json);
    });

    test('UserTierResponse fromJson and toJson', () {
      final json = {
        'user_id': 'usr_1001',
        'tier': 'DIAMOND',
        'badges': ['VERIFIED_OWNER', 'DIAMOND_BLACK'],
        'complex_name': '디에이치 방배',
        'building_unit': '101동 1502호',
        'security_profile': {
          'screen_capture_prevented': true,
          'privacy_masked': true,
        },
      };
      final userTier = UserTierResponse.fromJson(json);
      expect(userTier.userId, 'usr_1001');
      expect(userTier.tier, MembershipTier.diamond);
      expect(userTier.badges, [BadgeType.verifiedOwner, BadgeType.diamondBlack]);
      expect(userTier.complexName, '디에이치 방배');
      expect(userTier.buildingUnit, '101동 1502호');
      expect(userTier.securityProfile.screenCapturePrevented, true);
      expect(userTier.securityProfile.privacyMasked, true);

      expect(userTier.toJson(), json);
    });
  });
}
