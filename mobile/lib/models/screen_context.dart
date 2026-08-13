/// Represents the current screen context to be passed to the AI agent.
/// This enables the AI to give proactive, screen-aware 1-tap recommendations.
class ScreenContext {
  /// The current tab index in the main navigation bar (0-4).
  final int tabIndex;

  /// Human-readable name of the current screen.
  final String screenName;

  /// Optional supplementary data (e.g., currently displayed complex name,
  /// insight type, curation item title) for richer AI context.
  final Map<String, String> metadata;

  const ScreenContext({
    required this.tabIndex,
    required this.screenName,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'tab_index': tabIndex,
        'screen_name': screenName,
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  /// Returns the proactive 1-tap suggestion chips relevant to this context.
  List<String> get proactiveSuggestions {
    switch (tabIndex) {
      case 0: // 홈
        return [
          '오늘 자산 가치 변동 요약해줘',
          '클럽딜 마감 시간 알려줘',
          '시설 혼잡도 최신 현황',
        ];
      case 1: // 커뮤니티 라운지
        return [
          '익명 라운지 최신 인기 게시글 요약',
          '오늘 커뮤니티 주요 이슈',
          '게시글 작성 도움',
        ];
      case 2: // VVIP 큐레이션
        return [
          '이 큐레이션 상품 가격 비교해줘',
          '유사 VVIP 딜 찾아줘',
          '구매 전 체크리스트 알려줘',
        ];
      case 3: // 자산증식 인사이트
        return [
          '현재 공급가스 지수 설명해줘',
          '리스크 지수 높은 단지 어디야',
          'VIP 패밀리오피스 1:1 상담 예약해줘',
        ];
      case 4: // 내 정보
        return [
          '내 자산 인증 상태 확인',
          '티어 업그레이드 조건 알려줘',
          '보안 설정 점검해줘',
        ];
      default:
        return [
          '라운지 조식 2명 예약',
          '피트니스 센터 혼잡도 조회',
          '사우나 현재 이용 상태',
        ];
    }
  }

  /// Returns the context banner label shown at top of the AI overlay.
  String get contextLabel {
    final base = '현재 화면: $screenName';
    if (metadata.containsKey('complex')) {
      return '$base · ${metadata['complex']}';
    }
    return base;
  }
}
