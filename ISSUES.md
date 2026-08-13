# 📋 ARATEL (아라뜰) 프로젝트 구현 이슈 목록 (Issue Backlog)

본 문서는 `arch.docx` 및 `flow.docx` 기획서를 바탕으로 **ARATEL** 플랫폼 구축에 필요한 핵심 기능 및 정식 릴리즈 전 보안/성능/운용/UI/UX 고도화 백로그 이슈(총 36개)를 정리한 목록입니다.

---

## 📌 Epic 1: 인증 & 회원가입 (Verification & Tiering Governance)

### [#1] 1분 자동 등기부 연동 실소유주 인증 시스템 구축 (Trust API Sync) [✅ 완료]
* **카테고리**: `Backend`, `Mobile`
* **설명**: 휴대폰 본인인증 모듈과 암호화된 실시간 등기부 API를 연동하여 1분 이내에 소유권을 자동 매칭하고 `Verified Owner` 뱃지를 부여합니다.

### [#2] 대리인 및 가족 권한 위임 프로세스 (Delegated Access) [✅ 완료]
* **카테고리**: `Backend`, `Mobile`, `Web`
* **설명**: 실명 명의자 외 실거주 가족 및 자산 관리인을 위한 권한 위임 절차를 제공합니다.

### [#3] VVIP 자산 증빙 심사 및 멤버십 등급 산정 시스템 (Tiering Governance) [✅ 완료]
* **카테고리**: `Backend`, `Web`, `Mobile`
* **설명**: 소득금액증명원, 잔고 증명서, 등기완료통지서 및 사회적 영향력을 심사하여 Diamond, Platinum, Gold, Bronze 등급을 산정합니다.

### [#4] 모바일 화면 캡처 방지 및 개인정보 보안 레이어 (Security Layer) [✅ 완료]
* **카테고리**: `Mobile`
* **설명**: 정보 유출을 원천 차단하기 위해 앱 내 화면 캡처 및 녹화를 방지하고 개인정보 마스킹을 적용합니다.

---

## 💬 Epic 2: 소통 & 디지털 웰컴 홈 (Communication & Welcome Home)

### [#5] 단지별 디지털 웰컴 홈 & 조경 아트 도슨트 [✅ 완료]
* **카테고리**: `Web`, `Mobile`
* **설명**: 인증된 단지 소유주에게 맞춤형 웰컴 화면을 제공하며, 조경 스토리 및 예술품 전문 도슨트 기능을 이식합니다.

### [#6] 실시간 단지 커뮤니티 시설 혼잡도 & 스마트홈 위젯 [✅ 완료]
* **카테고리**: `Backend`, `Mobile`, `Web`
* **설명**: 피트니스, 스카이라운지 조식 등 단지 시설의 실시간 혼잡도 및 스마트홈 기기 제어를 통합 제공합니다.

### [#7] 자연어 대화형 AI 에이전트 생활 제어 (Otiaire Integration) [✅ 완료]
* **카테고리**: `Backend`, `Mobile`
* **설명**: 자연어 음성/텍스트 명령을 통해 라운지 조식 예약, 사우나 혼잡도 조회 등을 AI가 처리합니다.

### [#8] 양방향 암호화 폐쇄형 익명 라운지 (Exclusive Social) [✅ 완료]
* **카테고리**: `Backend`, `Mobile`, `Web`
* **설명**: 작성 시마다 닉네임이 변경되는 다이나믹 익명성을 제공하되, 인증 뱃지+단지명을 조합하여 발언의 무게감을 부여합니다.

### [#9] 24시간 AI 클린 시그널 모니터링 시스템 [✅ 완료]
* **카테고리**: `Backend`
* **설명**: 투기성 노이즈, 비방, 허위 정보를 24시간 실시간 감지하여 순수 데이터(Clean Signal) 환경을 유지합니다.

### [#10] 고가치 정보 보상(Aratel Point) & Trust Score 상단 노출 알고리즘 [✅ 완료]
* **카테고리**: `Backend`, `Mobile`
* **설명**: 양질의 정보 공유자에게 아라뜰 포인트를 지급하고, Diamond 등급의 고급 절세/투자 정보에 가중치를 부여합니다.

---

## 🛍️ Epic 3: 소비 & AI 아뜰리에 (Consumption & VIP Concierge)

### [#11] AI 아뜰리에 3D 가상 공간 인테리어 시뮬레이션 [✅ 완료]
* **카테고리**: `Web`, `Mobile`
* **설명**: 사용자의 아파트 평면도에 명품 수입 가구를 가상 배치하는 3D 시뮬레이션 인터페이스입니다.

### [#12] 수입 브랜드 '클럽 딜 (Club Deal)' 프라이빗 공동 오더 [✅ 완료]
* **카테고리**: `Backend`, `Web`, `Mobile`
* **설명**: 동일 단지 사용자가 3D 시뮬레이션 시 클럽 딜 알림이 발송되며, 포인트를 활용한 프라이빗 공동 구매를 진행합니다.

### [#13] VIP 컨시어지 & 웰니스 서비스 통합 예약 [✅ 완료]
* **카테고리**: `Backend`, `Web`, `Mobile`
* **설명**: 자산관리(우리은행 TWO CHAIRS), 럭셔리 주거 방역, 건강검진, 아트 구독 예약 허브를 구축합니다.

---

## ⚙️ Epic 4: 백엔드 API & 인프라 (Backend & Infrastructure)

### [#14] Rails 8.0 RESTful/GraphQL API & JWT 인증 인프라 [✅ 완료]
* **카테고리**: `Backend`
* **설명**: Rails 8.0 기반의 고성능 API 서버 및 모바일/웹 공용 보안 인증 인프라를 구축합니다.

### [#15] '아실' 기반 실거래가 층수 산점도 & 공급 물량 파이프라인 [✅ 완료]
* **카테고리**: `Backend`
* **설명**: 층수별 실거래 전위차 및 주변 입주 예정 물량('공급 독성 가스')을 수집·분석하는 파이프라인입니다.

### [#16] Rails 백오피스 어드민 포털 (Admin & Governance) [✅ 완료]
* **카테고리**: `Backend`, `Web`
* **설명**: VVIP 자산 증빙 수동 심사, 단지 관리, 유출 모니터링을 위한 어드민 시스템을 구축합니다.

---

## 🎨 Epic 5: 프론트엔드 UI/UX (Frontend UI/UX)

### [#17] Flutter 모바일 VVIP 럭셔리 디자인 시스템 구축 [✅ 완료]
* **카테고리**: `Mobile`
* **설명**: Satin Gold(#D4AF37), Diamond Black 등 고급스러운 VVIP 아이덴티티 디자인 시스템을 구축합니다.

### [#18] Rails Web 반응형 프론트엔드 & SEO 랜딩 페이지 [✅ 완료]
* **카테고리**: `Web`
* **설명**: 데스크톱 웹 환경에 최적화된 반응형 UI 및 대외 홍보용 SEO 랜딩 페이지를 구현합니다.

---

## 🎨 Epic 6: 회고 기반 사용성(UX) & 하이엔드 디자인 고도화 (UX Retrospective & Design Perfection)

### [#19] UX: 1분 등기부 자동 인증 홀로그램 스캐닝 마이크로 애니메이션 & 스텝 프로그래스 [✅ 완료]
* **카테고리**: `Web`, `Mobile`
* **라벨**: `enhancement`, `UX`, `epic:design`
* **설명**: 등기부 데이터 스캐닝 모션 및 3단계 라이브 상태 표시 구현.

### [#20] UX: AI 아뜰리에 3D 가구 배치 2D Top-Down ↔ 3D 입체 듀얼 스냅 조작 컨트롤러 [✅ 완료]
* **카테고리**: `Web`, `Mobile`
* **라벨**: `enhancement`, `UX`, `3D`, `epic:design`
* **설명**: 2D 평면도 및 3D 시점 전환 듀얼 토글 스위치 제공.

### [#21] UX: 자연어 AI 에이전트 Quick Suggestion Chips & 인터랙티브 음성 파동 시각화 [✅ 완료]
* **카테고리**: `Mobile`, `Web`
* **라벨**: `enhancement`, `AI`, `UX`, `epic:design`
* **설명**: AI 에이전트 대화 창 내 추천 명령 칩(Chips) 및 파동 시각화 연동.

### [#22] Design: Diamond/Platinum 뱃지 홀로그램 빛 반사 효과 & 아실 차트 Glow 입자 시각화 [✅ 완료]
* **카테고리**: `Web`, `Mobile`
* **라벨**: `enhancement`, `UI/UX`, `epic:design`
* **설명**: 하이엔드 자산가 뱃지 호버 반응형 쉐이더 및 실거래가 차트 발광 시각화.

---

## 🚀 Epic 7: 프로덕트 정식 출시 전 보안·성능·운용·UX 고도화 (Pre-Launch Production Readiness)

### [#23] Sec: API Rate Limiting, CORS Policy & Devise Token Security Hardening [✅ 완료]
### [#24] Sec: Zero-Knowledge Payload Sanitization & Admin PII Privacy Masking Audit [✅ 완료]
### [#25] Perf: Cloud Database Indexing & High-Frequency API Redis Caching Layer [✅ 완료]
### [#26] Perf: 3D GLTF Asset Compression & WebP Audio Asset CDN Optimization Pipeline [✅ 완료]
### [#27] Ops: Sentry Error Tracking & Real-Time Performance APM Telemetry Setup [✅ 완료]
### [#28] Ops: GitHub Actions Multi-Stack CI/CD Pipeline & Automated Staging Deployment [✅ 완료]
### [#29] UX: Holographic Scan Animation & Multi-Step Progress Tracker for Trust API Sync [✅ 완료]
### [#30] UX: Interactive Voice Waveform Visualizer & One-Tap Suggestion Chips for AI Agent [✅ 완료]
### [#31] Design: Dynamic Gyroscope Holographic Depth Badge Shader & Glow Scatter Plot [✅ 완료]

---

## 🎨 Epic 8: UI & User Flow 출시 전 감성·UX 완결성 고도화 (Pre-Launch UI & User Flow Polish)

### [#32] UI/UX: 소유권 자동 인증 및 자산 증빙 마법사(Wizard) 다단계 상태 트래커
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `user-flow`, `verification`
* **점검 내용**:
  * [ ] 1분 본인인증 ➔ 실시간 등기부 조회 ➔ VVIP 자산 증빙 제출 흐름 간 다단계 마법사(Step Wizard) 프로그래스 바 연동
  * [ ] 등기부 조회 실패 시 사용자 대응 가이드 툴팁 및 1-Tap 재시도 UX 제공

### [#33] UI/UX: 커뮤니티 서브 탭 필터 칩, Pull-to-Refresh & 스켈레톤 쉬머 로딩 UX
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `user-flow`, `community`
* **점검 내용**:
  * [ ] 전체 피드 / 단지 게시판 / 익명 라운지 탭 전환 시 부드러운 필터 칩(Filter Pills) 애니메이션
  * [ ] 모바일 Pull-to-Refresh 및 웹/앱 데이터 로딩 시 카드 스켈레톤(Skeleton Shimmer) 로딩 UI 제공

### [#34] UI/UX: 3D 아뜰리에 카메라스위처 & 클럽딜 주문 단계별 스테퍼 (Stepper)
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `3D`, `club-deal`
* **점검 내용**:
  * [ ] 2D Top-Down ↔ 3D 오비트 조작 시 Smooth Camera Transition 애니메이션 적용
  * [ ] 클럽 딜 공동 오더 진행 상태(모집 중 ➔ 주문 완료 ➔ 배송 준비 ➔ 배송 완료) 4단계 시각적 스테퍼 모달 구현

### [#35] UI/UX: 아실 실거래가 층수 산점도 Zoom 줌 슬라이더 & 공급 독성 가스 게이지 메터
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `chart`, `insights`
* **점검 내용**:
  * [ ] 층수별 실거래 산점도 차트에 층수 핀치 줌 & 층수 범위(Range Slider) 필터 컨트롤러 연동
  * [ ] 입주 예정 물량 위험도('공급 독성 가스') 게이지 메터(Gauge Meter) 비주얼 라이브 시각화

### [#36] UI/UX: 조경 오디오 도슨트 플로팅 플레이어 & 야간 커뮤니티 시설 운영시간 처리
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `welcome-home`, `player`
* **점검 내용**:
  * [ ] 조경 아트 도슨트 재배 시 하단 미니 오디오 플로팅 플레이어(Floating Audio Widget) 렌더링
  * [ ] 심야 시간대 피트니스/사우나 시설 미운영 시 "운영 준비 중" 상태 카드 및 운영 시간 가이드 UI 적용

---

## 🚀 Epic 9: VVIP 클럽딜 & 실거래가 인사이트 UI/UX 고도화 (Issues #25 & #26)

### [#25] UI/UX: VVIP Club Deal Order Lifecycle Stepper & Point Calculator Slider
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `club-deal`, `user-flow`
* **GitHub Issue**: [#25](https://github.com/gomjunho/aratel/issues/25)
* **점검 내용**:
  * [ ] 주문 상태 4단계 라이브 타임라인 스태퍼 (`주문 완료` ➔ `단지 수량 확정` ➔ `이탈리아 직배송` ➔ `전문 기사 방문 설치`)
  * [ ] 결제 모달 포인트 차감 슬라이더 계산기 (1,000 P 단위 실시간 슬라이더 조절)
  * [ ] 딜 종료 카운트다운 파티클 타이머 (`⏱️ 딜 종료까지 XX시간 XX분`)

### [#26] UI/UX: Asil Insights Area Size Filter Switcher & Scatter Plot Zoom Slider
* **카테고리**: `Web`, `Mobile`
* **라벨**: `UI/UX`, `insights`, `chart`
* **GitHub Issue**: [#26](https://github.com/gomjunho/aratel/issues/26)
* **점검 내용**:
  * [ ] 평형별 세그먼트 스위처 (`59㎡`, `84㎡`, `114㎡`, `164㎡ (펜트하우스)`)
  * [ ] 산점도 차트 Zoom/Pan 컨트롤러 (`+` / `-` 줌 슬라이더 및 데이터 포인트 상세 모달 팝업)
  * [ ] 공급 물량 독성 지수 리포트 상세 레이어 바텀시트 연동
