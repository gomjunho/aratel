enum MembershipTier {
  diamond,
  platinum,
  gold,
  bronze;

  static MembershipTier fromString(String value) {
    switch (value.toUpperCase()) {
      case 'DIAMOND':
        return MembershipTier.diamond;
      case 'PLATINUM':
        return MembershipTier.platinum;
      case 'GOLD':
        return MembershipTier.gold;
      case 'BRONZE':
      default:
        return MembershipTier.bronze;
    }
  }

  String toValue() {
    switch (this) {
      case MembershipTier.diamond:
        return 'DIAMOND';
      case MembershipTier.platinum:
        return 'PLATINUM';
      case MembershipTier.gold:
        return 'GOLD';
      case MembershipTier.bronze:
        return 'BRONZE';
    }
  }
}

enum BadgeType {
  verifiedOwner,
  resident,
  diamondBlack,
  platinumSilver,
  goldEmblem,
  bronzeMetallic;

  static BadgeType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'VERIFIED_OWNER':
        return BadgeType.verifiedOwner;
      case 'RESIDENT':
        return BadgeType.resident;
      case 'DIAMOND_BLACK':
        return BadgeType.diamondBlack;
      case 'PLATINUM_SILVER':
        return BadgeType.platinumSilver;
      case 'GOLD_EMBLEM':
        return BadgeType.goldEmblem;
      case 'BRONZE_METALLIC':
        return BadgeType.bronzeMetallic;
      default:
        return BadgeType.verifiedOwner;
    }
  }

  String toValue() {
    switch (this) {
      case BadgeType.verifiedOwner:
        return 'VERIFIED_OWNER';
      case BadgeType.resident:
        return 'RESIDENT';
      case BadgeType.diamondBlack:
        return 'DIAMOND_BLACK';
      case BadgeType.platinumSilver:
        return 'PLATINUM_SILVER';
      case BadgeType.goldEmblem:
        return 'GOLD_EMBLEM';
      case BadgeType.bronzeMetallic:
        return 'BRONZE_METALLIC';
    }
  }
}

enum VerificationStatus {
  unverified,
  pending,
  verified,
  rejected;

  static VerificationStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'UNVERIFIED':
        return VerificationStatus.unverified;
      case 'PENDING':
        return VerificationStatus.pending;
      case 'VERIFIED':
        return VerificationStatus.verified;
      case 'REJECTED':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.unverified;
    }
  }

  String toValue() {
    switch (this) {
      case VerificationStatus.unverified:
        return 'UNVERIFIED';
      case VerificationStatus.pending:
        return 'PENDING';
      case VerificationStatus.verified:
        return 'VERIFIED';
      case VerificationStatus.rejected:
        return 'REJECTED';
    }
  }
}

class IdentityVerifyRequest {
  final String name;
  final String phoneNumber;
  final String birthDate;

  const IdentityVerifyRequest({
    required this.name,
    required this.phoneNumber,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone_number': phoneNumber,
        'birth_date': birthDate,
      };

  factory IdentityVerifyRequest.fromJson(Map<String, dynamic> json) {
    return IdentityVerifyRequest(
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      birthDate: json['birth_date'] as String,
    );
  }
}

class IdentityVerifyResponse {
  final String status;
  final String verificationToken;
  final String maskedName;
  final String verifiedAt;

  const IdentityVerifyResponse({
    required this.status,
    required this.verificationToken,
    required this.maskedName,
    required this.verifiedAt,
  });

  factory IdentityVerifyResponse.fromJson(Map<String, dynamic> json) {
    return IdentityVerifyResponse(
      status: json['status'] as String,
      verificationToken: json['verification_token'] as String,
      maskedName: json['masked_name'] as String,
      verifiedAt: json['verified_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'verification_token': verificationToken,
        'masked_name': maskedName,
        'verified_at': verifiedAt,
      };
}

class TrustApiSyncRequest {
  final String verificationToken;
  final String complexName;
  final String buildingNumber;
  final String unitNumber;

  const TrustApiSyncRequest({
    required this.verificationToken,
    required this.complexName,
    required this.buildingNumber,
    required this.unitNumber,
  });

  Map<String, dynamic> toJson() => {
        'verification_token': verificationToken,
        'complex_name': complexName,
        'building_number': buildingNumber,
        'unit_number': unitNumber,
      };

  factory TrustApiSyncRequest.fromJson(Map<String, dynamic> json) {
    return TrustApiSyncRequest(
      verificationToken: json['verification_token'] as String,
      complexName: json['complex_name'] as String,
      buildingNumber: json['building_number'] as String,
      unitNumber: json['unit_number'] as String,
    );
  }
}

class TrustApiSyncResponse {
  final VerificationStatus status;
  final String ownerNameMasked;
  final num ownershipPercentage;
  final BadgeType badge;
  final MembershipTier assignedTier;
  final String verifiedAt;

  const TrustApiSyncResponse({
    required this.status,
    required this.ownerNameMasked,
    required this.ownershipPercentage,
    required this.badge,
    required this.assignedTier,
    required this.verifiedAt,
  });

  factory TrustApiSyncResponse.fromJson(Map<String, dynamic> json) {
    return TrustApiSyncResponse(
      status: VerificationStatus.fromString(json['status'] as String),
      ownerNameMasked: json['owner_name_masked'] as String,
      ownershipPercentage: json['ownership_percentage'] as num,
      badge: BadgeType.fromString(json['badge'] as String),
      assignedTier: MembershipTier.fromString(json['assigned_tier'] as String),
      verifiedAt: json['verified_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.toValue(),
        'owner_name_masked': ownerNameMasked,
        'ownership_percentage': ownershipPercentage,
        'badge': badge.toValue(),
        'assigned_tier': assignedTier.toValue(),
        'verified_at': verifiedAt,
      };
}

class DelegatedAccessRequest {
  final String relationship;
  final String documentUrl;

  const DelegatedAccessRequest({
    required this.relationship,
    required this.documentUrl,
  });

  Map<String, dynamic> toJson() => {
        'relationship': relationship,
        'document_url': documentUrl,
      };

  factory DelegatedAccessRequest.fromJson(Map<String, dynamic> json) {
    return DelegatedAccessRequest(
      relationship: json['relationship'] as String,
      documentUrl: json['document_url'] as String,
    );
  }
}

class DelegatedAccessResponse {
  final String delegationId;
  final String status;
  final String requestedAt;

  const DelegatedAccessResponse({
    required this.delegationId,
    required this.status,
    required this.requestedAt,
  });

  factory DelegatedAccessResponse.fromJson(Map<String, dynamic> json) {
    return DelegatedAccessResponse(
      delegationId: json['delegation_id'] as String,
      status: json['status'] as String,
      requestedAt: json['requested_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'delegation_id': delegationId,
        'status': status,
        'requested_at': requestedAt,
      };
}

class OwnerApprovalRequest {
  final bool approved;

  const OwnerApprovalRequest({
    required this.approved,
  });

  Map<String, dynamic> toJson() => {
        'approved': approved,
      };

  factory OwnerApprovalRequest.fromJson(Map<String, dynamic> json) {
    return OwnerApprovalRequest(
      approved: json['approved'] as bool,
    );
  }
}

class OwnerApprovalResponse {
  final String delegationId;
  final String status;
  final BadgeType? grantedBadge;
  final String? role;

  const OwnerApprovalResponse({
    required this.delegationId,
    required this.status,
    this.grantedBadge,
    this.role,
  });

  factory OwnerApprovalResponse.fromJson(Map<String, dynamic> json) {
    return OwnerApprovalResponse(
      delegationId: json['delegation_id'] as String,
      status: json['status'] as String,
      grantedBadge: json['granted_badge'] != null ? BadgeType.fromString(json['granted_badge'] as String) : null,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'delegation_id': delegationId,
        'status': status,
        if (grantedBadge != null) 'granted_badge': grantedBadge!.toValue(),
        if (role != null) 'role': role,
      };
}

class TierEvidenceRequest {
  final String evidenceType;
  final String documentUrl;
  final String? instagramHandle;
  final String? referralCode;

  const TierEvidenceRequest({
    required this.evidenceType,
    required this.documentUrl,
    this.instagramHandle,
    this.referralCode,
  });

  Map<String, dynamic> toJson() => {
        'evidence_type': evidenceType,
        'document_url': documentUrl,
        if (instagramHandle != null) 'instagram_handle': instagramHandle,
        if (referralCode != null) 'referral_code': referralCode,
      };

  factory TierEvidenceRequest.fromJson(Map<String, dynamic> json) {
    return TierEvidenceRequest(
      evidenceType: json['evidence_type'] as String,
      documentUrl: json['document_url'] as String,
      instagramHandle: json['instagram_handle'] as String?,
      referralCode: json['referral_code'] as String?,
    );
  }
}

class TierEvidenceResponse {
  final String submissionId;
  final String status;
  final MembershipTier targetTier;
  final String submittedAt;

  const TierEvidenceResponse({
    required this.submissionId,
    required this.status,
    required this.targetTier,
    required this.submittedAt,
  });

  factory TierEvidenceResponse.fromJson(Map<String, dynamic> json) {
    return TierEvidenceResponse(
      submissionId: json['submission_id'] as String,
      status: json['status'] as String,
      targetTier: MembershipTier.fromString(json['target_tier'] as String),
      submittedAt: json['submitted_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'submission_id': submissionId,
        'status': status,
        'target_tier': targetTier.toValue(),
        'submitted_at': submittedAt,
      };
}

class SecurityProfile {
  final bool screenCapturePrevented;
  final bool privacyMasked;

  const SecurityProfile({
    required this.screenCapturePrevented,
    required this.privacyMasked,
  });

  factory SecurityProfile.fromJson(Map<String, dynamic> json) {
    return SecurityProfile(
      screenCapturePrevented: json['screen_capture_prevented'] as bool,
      privacyMasked: json['privacy_masked'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'screen_capture_prevented': screenCapturePrevented,
        'privacy_masked': privacyMasked,
      };
}

class UserTierResponse {
  final String userId;
  final MembershipTier tier;
  final List<BadgeType> badges;
  final String complexName;
  final String buildingUnit;
  final SecurityProfile securityProfile;

  const UserTierResponse({
    required this.userId,
    required this.tier,
    required this.badges,
    required this.complexName,
    required this.buildingUnit,
    required this.securityProfile,
  });

  factory UserTierResponse.fromJson(Map<String, dynamic> json) {
    return UserTierResponse(
      userId: json['user_id'] as String,
      tier: MembershipTier.fromString(json['tier'] as String),
      badges: (json['badges'] as List<dynamic>)
          .map((b) => BadgeType.fromString(b as String))
          .toList(),
      complexName: json['complex_name'] as String,
      buildingUnit: json['building_unit'] as String,
      securityProfile: SecurityProfile.fromJson(json['security_profile'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'tier': tier.toValue(),
        'badges': badges.map((b) => b.toValue()).toList(),
        'complex_name': complexName,
        'building_unit': buildingUnit,
        'security_profile': securityProfile.toJson(),
      };
}
