# 🎨 AI 툴을 활용한 시각화 및 개발 연동 가이드라인 (AI Visualization & Development Integration)

> **문서 버전**: v1.0  
> **작성일**: 2026-08-13  
> **관련 이슈**: [#19](https://github.com/gomjunho/aratel/issues/19)

---

## 1. 📌 Overview

본 가이드라인은 Google Stitch, Uizard, v0.dev, Antigravity Agent 등 AI 도구를 활용하여 ARATEL의 정보 구조(IA) 및 와이어프레임을 시각적 프로토타입 시안으로 발전시키고, 이를 프로덕션급 Flutter 위젯 코드 파이프라인으로 변환하는 워크플로우를 정의합니다.

---

## 2. 🤖 AI 파이프라인 3단계 워크플로우

```
┌───────────────────────────┐      ┌───────────────────────────┐      ┌───────────────────────────┐
│  Phase 1: 와이어프레임    │ ───► │  Phase 2: 시각화 시안     │ ───► │  Phase 3: 코드 변환/검증  │
│  (IA & Wireframe Spec)    │      │  (Google Stitch / Uizard) │      │  (Antigravity / Flutter)  │
└───────────────────────────┘      └───────────────────────────┘      └───────────────────────────┘
```

---

## 3. 🎨 Phase 1 & 2: Google Stitch / Uizard 프롬프트 전략

### ARATEL VVIP 다크 테마 프로토타이핑 프롬프트 템플릿

```text
Design a luxury VVIP real estate mobile app screen for "ARATEL".
- Theme: Deep Navy Charcoal (#0F1115 base background, #161920 card surface, #1E222B elevated container)
- Accent: Satin Gold (#D4AF37) for VIP badges and primary CTA buttons
- Layout: Modern Korean super-app style (similar to Toss TDS, soft 12px rounded corners)
- Header: Owner profile card with Holographic Diamond VVIP Badge
- Visual elements: High-contrast typography, subtle 4px blur glow effects, clear visual hierarchy
```

---

## 4. ⚡ Phase 3: Antigravity / Flutter 코드 변환 및 표준 위젯 매핑

| AI 프롬프트 요소 | ARATEL Flutter 컴포넌트 매핑 | 디자인 토큰 매핑 |
|:---|:---|:---|
| **표준 리스트 아이템** | `AratelListRow` (`lib/widgets/aratel_list_row.dart`) | `AppColors.bgSurface`, `AppTypography.titleMedium` |
| **로딩 스켈레톤** | `ShimmerSkeleton` (`lib/widgets/shimmer_skeleton.dart`) | `AppColors.bgElevated` ➔ `AppColors.bgTop` |
| **하단 고정 버튼** | `StickyBottomCTA` (`lib/widgets/sticky_bottom_cta.dart`) | `AppColors.satinGold`, `HapticFeedback.mediumImpact()` |
| **홀로그램 배지** | `_HolographicBadge` (`profile_screen.dart`) | `LinearGradient`, lerped gold/white shadow |
| **실거래가 산점도** | `_GlowScatterChartPainter` (`insights_screen.dart`) | `CustomPainter`, `MaskFilter.blur`, Orbit Particles |

---

## 5. 🧪 검증 및 CI/CD 파이프라인연동

1. **Flutter Widget Test 검증**: 생성된 위젯은 `test/widgets/` 경로에 렌더링 및 인터랙션 테스트 작성
2. **DTD & Hot Reload 라이브 검증**: `dtd` 및 `hot_reload` 도구를 통한 실시간 디바이스 UI 검증
3. **GitHub Actions CI 워크플로우**: PR 생성 시 `flutter test` 자동 검증 수행
