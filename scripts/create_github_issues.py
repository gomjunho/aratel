#!/usr/bin/env python3
import subprocess
import sys

issues = [
    {
        "title": "[#1] 1분 자동 등기부 연동 실소유주 인증 시스템 구축 (Trust API Sync)",
        "body": "### 📌 개요\n휴대폰 본인인증 모듈과 암호화된 실시간 등기부 API를 연동하여 1분 이내에 소유권을 자동 매칭하고 `Verified Owner` 뱃지를 부여합니다.\n\n### 🛠 상세 작업\n- [ ] 휴대폰 본인인증 핀테크 SDK 연동 (Backend API)\n- [ ] 대법원/암호화 등기부 실시간 조회 API 동기화 모듈 개발\n- [ ] 본인인증 명의와 등기부 소유자 실시간 알고리즘 매칭\n- [ ] Flutter 앱 Asset Scanning -> Identity Auth -> Registry Sync UI 구현\n\n### ✅ 완료 조건\n단지 상세 주소 및 본인 인증 시 1분 내 소유권 검증 및 뱃지 자동 활성화",
        "labels": ["feature", "security", "epic:verification"]
    },
    {
        "title": "[#2] 대리인 및 가족 권한 위임 프로세스 (Delegated Access)",
        "body": "### 📌 개요\n실명 명의자 외 실거주 가족 및 자산 관리인을 위한 권한 위임 절차를 제공합니다.\n\n### 🛠 상세 작업\n- [ ] 가족관계증명서 및 위임장 서류 업로드 API 개발\n- [ ] 명의자 앱 내 Push 승인 및 웹 어드민 수동 검증 프로세스 구축\n- [ ] `Resident` (실거주자) 뱃지 발급 및 커뮤니티 접근 권한 차등화 로직 구현\n\n### ✅ 완료 조건\n명의자 승인 완료 시 가족/관리인 계정에 Resident 뱃지 부여 및 제한적 권한 활성화",
        "labels": ["feature", "epic:verification"]
    },
    {
        "title": "[#3] VVIP 자산 증빙 심사 및 멤버십 등급 산정 시스템 (Tiering Governance)",
        "body": "### 📌 개요\n소득금액증명원, 잔고 증명서, 등기완료통지서 및 사회적 영향력을 심사하여 Diamond, Platinum, Gold, Bronze 등급을 산정합니다.\n\n### 🛠 상세 작업\n- [ ] 증빙 서류 업로드 및 암호화 저장소 구현\n- [ ] 셀러브리티/인플루언서 인스타그램 연동 및 기존 회원 추천 코드 시스템\n- [ ] 자산 규모별 자동/수동 등급 부여 로직 및 다이아몬드 블랙, 플래티넘 실버 뱃지 시각화 API\n\n### ✅ 완료 조건\n제출된 증빙 자료에 따른 4단계 멤버십 등급 자동 및 어드민 승인 프로세스 완성",
        "labels": ["feature", "epic:verification"]
    },
    {
        "title": "[#4] 모바일 화면 캡처 방지 및 개인정보 보안 레이어 (Security Layer)",
        "body": "### 📌 개요\n정보 유출을 원천 차단하기 위해 앱 내 화면 캡처 및 녹화를 방지하고 개인정보 마스킹을 적용합니다.\n\n### 🛠 상세 작업\n- [ ] Flutter iOS/Android 화면 캡처 방지 적용\n- [ ] 라운지 내 텍스트 캡처 방지 및 사용자 워터마크 동적 투영\n- [ ] 등기 및 민감 정보 마스킹 뷰어 개발",
        "labels": ["security", "epic:verification"]
    },
    {
        "title": "[#5] 단지별 디지털 웰컴 홈 & 조경 아트 도슨트",
        "body": "### 📌 개요\n인증된 단지 소유주에게 맞춤형 웰컴 화면을 제공하며, 조경 스토리 및 예술품 전문 도슨트 기능을 이식합니다.\n\n### 🛠 상세 작업\n- [ ] 단지별 조경 스토리 & 설치 미술품 가상 도슨트 카드 UI 개발\n- [ ] 오티에르(Otiaire) 감성 디자인 이식",
        "labels": ["feature", "UI/UX", "epic:communication"]
    },
    {
        "title": "[#6] 실시간 단지 커뮤니티 시설 혼잡도 & 스마트홈 위젯",
        "body": "### 📌 개요\n피트니스, 스카이라운지 조식 등 단지 시설의 실시간 혼잡도 및 스마트홈 기기 제어를 통합 제공합니다.\n\n### 🛠 상세 작업\n- [ ] 커뮤니티 시설 실시간 예약 및 혼잡도 API 구축\n- [ ] 조명, 환기, 난방 제어를 위한 스마트홈 API 연동 위젯 개발",
        "labels": ["feature", "epic:communication"]
    },
    {
        "title": "[#7] 자연어 대화형 AI 에이전트 생활 제어 (Otiaire Integration)",
        "body": "### 📌 개요\n자연어 음성/텍스트 명령을 통해 라운지 조식 예약, 사우나 혼잡도 조회 등을 AI가 처리합니다.\n\n### 🛠 상세 작업\n- [ ] LLM (Gemini API) 연동 및 에이전트 파이프라인 구축\n- [ ] 자연어 질의 -> 예약 API 함수 호출(Function Calling) 연결\n- [ ] Flutter 모바일 AI 대화창 인터페이스 구현",
        "labels": ["AI", "feature", "epic:communication"]
    },
    {
        "title": "[#8] 양방향 암호화 폐쇄형 익명 라운지 (Exclusive Social)",
        "body": "### 📌 개요\n다이나믹 익명성을 제공하되, 인증 뱃지+단지명을 조합하여 발언의 무게감을 부여합니다.\n\n### 🛠 상세 작업\n- [ ] 대화 및 게시글 군사 등급 양방향 암호화 저장/전송 체계 구축\n- [ ] 랜덤 닉네임 생성기 + Verified Badge + 단지명 상시 표기 UI\n- [ ] 정보 유출 발생 시 추적 알고리즘 및 영구 제명 시스템",
        "labels": ["feature", "security", "epic:communication"]
    },
    {
        "title": "[#9] 24시간 AI 클린 시그널 모니터링 시스템",
        "body": "### 📌 개요\n투기성 노이즈, 비방, 허위 정보를 24시간 실시간 감지하여 순수 데이터 환경을 유지합니다.",
        "labels": ["AI", "security", "epic:communication"]
    },
    {
        "title": "[#10] 고가치 정보 보상(Aratel Point) & Trust Score 상단 노출 알고리즘",
        "body": "### 📌 개요\n양질의 정보 공유자에게 아라뜰 포인트를 지급하고, Diamond 등급의 고급 정보에 가중치를 부여합니다.",
        "labels": ["feature", "algorithm", "epic:communication"]
    },
    {
        "title": "[#11] AI 아뜰리에 3D 가상 공간 인테리어 시뮬레이션",
        "body": "### 📌 개요\n사용자의 아파트 평면도에 명품 수입 가구를 가상 배치하는 3D 시뮬레이션 인터페이스입니다.",
        "labels": ["feature", "AI", "3D", "epic:consumption"]
    },
    {
        "title": "[#12] 수입 브랜드 '클럽 딜 (Club Deal)' 프라이빗 공동 오더",
        "body": "### 📌 개요\n동일 단지 사용자가 3D 시뮬레이션 시 클럽 딜 알림이 발송되며, 포인트를 활용한 프라이빗 공동 구매를 진행합니다.",
        "labels": ["feature", "commerce", "epic:consumption"]
    },
    {
        "title": "[#13] VIP 컨시어지 & 웰니스 서비스 통합 예약",
        "body": "### 📌 개요\n자산관리(우리은행 TWO CHAIRS), 럭셔리 주거 방역, 건강검진, 아트 구독 예약 허브를 구축합니다.",
        "labels": ["feature", "epic:consumption"]
    },
    {
        "title": "[#14] Rails 8.0 RESTful/GraphQL API & JWT 인증 인프라",
        "body": "### 📌 개요\nRails 8.0 기반의 고성능 API 서버 및 모바일/웹 공용 보안 인증 인프라를 구축합니다.",
        "labels": ["infrastructure", "epic:backend"]
    },
    {
        "title": "[#15] '아실' 기반 실거래가 층수 산점도 & 공급 물량 파이프라인",
        "body": "### 📌 개요\n층수별 실거래 전위차 및 주변 입주 예정 물량('공급 독성 가스')을 수집·분석하는 파이프라인입니다.",
        "labels": ["data", "epic:backend"]
    },
    {
        "title": "[#16] Rails 백오피스 어드민 포털 (Admin & Governance)",
        "body": "### 📌 개요\nVVIP 자산 증빙 수동 심사, 단지 관리, 유출 모니터링을 위한 어드민 시스템을 구축합니다.",
        "labels": ["admin", "epic:backend"]
    },
    {
        "title": "[#17] Flutter 모바일 VVIP 럭셔리 디자인 시스템 구축",
        "body": "### 📌 개요\nSatin Gold(#D4AF37), Diamond Black 등 고급스러운 VVIP 아이덴티티 디자인 시스템을 구축합니다.",
        "labels": ["UI/UX", "epic:frontend"]
    },
    {
        "title": "[#18] Rails Web 반응형 프론트엔드 & SEO 랜딩 페이지",
        "body": "### 📌 개요\n데스크톱 웹 환경에 최적화된 반응형 UI 및 대외 홍보용 SEO 랜딩 페이지를 구현합니다.",
        "labels": ["UI/UX", "SEO", "epic:frontend"]
    }
]

def main():
    print("Creating GitHub issues via gh CLI...")
    for item in issues:
        cmd = ["gh", "issue", "create", "--title", item["title"], "--body", item["body"]]
        for label in item.get("labels", []):
            cmd.extend(["--label", label])
        try:
            res = subprocess.run(cmd, capture_output=True, text=True)
            if res.returncode == 0:
                print(f"Created: {item['title']} -> {res.stdout.strip()}")
            else:
                print(f"Failed to create {item['title']}: {res.stderr.strip()}")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    main()
