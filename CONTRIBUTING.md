# 🛠️ ARATEL 개발 및 커밋 가이드라인 (Developer Guidelines)

ARATEL 프로젝트에 기여하거나 코드를 작성할 때 항상 준수해야 하는 **3대 핵심 규칙**입니다.

---

## 🧪 1. TDD (Test-Driven Development) 필수
* 모든 기능 개발, 리팩토링, 버그 수정은 **TDD (Red ➔ Green ➔ Refactor)** 방식으로 진행합니다.
* 비즈니스 로직 및 컴포넌트 추가 시 선(先) 테스트 코드 작성 후 기능을 구현합니다.
* **Backend**: `bin/rails test` (Rails Minitest / RSpec)
* **Web**: `bin/rails test`
* **Mobile**: `flutter test`

---

## 📊 2. Code Coverage 100% 유지 (Strict 100% Threshold)
* 프로젝트 내 모든 커버리지 지표는 항상 **100%**를 유지해야 합니다.
* **Backend & Web**: `SimpleCov.minimum_coverage 100`으로 100% 미만 시 CI/빌드가 자동으로 실패하도록 설정되어 있습니다.
* **Mobile**: `flutter test --coverage` 결과의 LCOV 누락 구간이 존재하지 않아야 합니다.

---

## 🎨 3. Gitmoji 커밋 메시지 컨벤션 (Gitmoji Standard)
* 모든 커밋 메시지의 접두사에는 **반드시 Gitmoji**를 포함해야 합니다.

### 📌 주요 Gitmoji 가이드
| Gitmoji | 이모지 | 설명 | 예시 |
| :--- | :---: | :--- | :--- |
| `:sparkles:` | ✨ | 새로운 기능 추가 | `:sparkles: feat: 1분 자동 등기부 인증 API 구현` |
| `:bug:` | 🐛 | 버그 수정 | `:bug: fix: JWT 토큰 만료 시간 계산 오류 수정` |
| `:memo:` | 📝 | 문서 작성 및 수정 | `:memo: docs: README에 TDD 및 Gitmoji 규칙 추가` |
| `:white_check_mark:` | ✅ | 테스트 코드 추가 및 수정 | `:white_check_mark: test: 라운지 암호화 로직 유닛 테스트 추가` |
| `:recycle:` | ♻️ | 코드 리팩토링 | `:recycle: refactor: 등기 매칭 알고리즘 구조 개선` |
| `:green_heart:` | 💚 | CI/CD 설정 및 수정 | `:green_heart: ci: GitHub Actions Flutter 빌드 캐싱 추가` |
| `:building_construction:` | 🏗️ | 아키텍처 및 스캐폴딩 변경 | `:building_construction: scaffold: Rails 및 Flutter 초기 환경 구성` |
| `:wrench:` | 🔧 | 설정 파일 수정 | `:wrench: config: SimpleCov 100% 최소 커버리지 옵션 변경` |
| `:lock:` | 🔒 | 보안 관련 기능 및 패치 | `:lock: security: 모바일 화면 캡처 방지 플러그인 연동` |
| `:palette:` | 🎨 | UI/UX 디자인 및 스타일 수정 | `:palette: style: Satin Gold 하이엔드 테마 색상 적용` |

---

## 🚀 CI/CD 자동 검증
모든 `git push` 및 `Pull Request`는 GitHub Actions CI에서 **TDD 테스트 및 100% Coverage** 조건을 자동으로 검증합니다.
