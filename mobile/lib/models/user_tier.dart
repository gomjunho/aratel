/// Defines the ARATEL member tier hierarchy and associated dashboard card weights.
enum UserTier {
  diamond,
  gold,
  silver,
  bronze,
  owner,
}

extension UserTierExtension on UserTier {
  String get label {
    switch (this) {
      case UserTier.diamond:
        return 'DIAMOND TIER';
      case UserTier.gold:
        return 'GOLD TIER';
      case UserTier.silver:
        return 'SILVER TIER';
      case UserTier.bronze:
        return 'BRONZE TIER';
      case UserTier.owner:
        return 'OWNER';
    }
  }

  /// Priority-sorted list of [DashboardCardType] for this tier.
  List<DashboardCardType> get dashboardCardOrder {
    switch (this) {
      case UserTier.diamond:
        return [
          DashboardCardType.assetValueSummary,
          DashboardCardType.urgentClubDeal,
          DashboardCardType.valueChainShortcuts,
          DashboardCardType.facilityStatus,
          DashboardCardType.audioDocent,
        ];
      case UserTier.gold:
        return [
          DashboardCardType.urgentClubDeal,
          DashboardCardType.assetValueSummary,
          DashboardCardType.valueChainShortcuts,
          DashboardCardType.facilityStatus,
          DashboardCardType.audioDocent,
        ];
      case UserTier.silver:
      case UserTier.bronze:
        return [
          DashboardCardType.valueChainShortcuts,
          DashboardCardType.facilityStatus,
          DashboardCardType.audioDocent,
          DashboardCardType.urgentClubDeal,
          DashboardCardType.assetValueSummary,
        ];
      case UserTier.owner:
        return [
          DashboardCardType.facilityStatus,
          DashboardCardType.communityAnnouncement,
          DashboardCardType.valueChainShortcuts,
          DashboardCardType.audioDocent,
          DashboardCardType.urgentClubDeal,
        ];
    }
  }
}

enum DashboardCardType {
  assetValueSummary,
  urgentClubDeal,
  valueChainShortcuts,
  facilityStatus,
  audioDocent,
  communityAnnouncement,
}
