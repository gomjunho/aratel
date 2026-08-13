# 📘 ARATEL (아라뜰) 개발 및 문제 해결 가이드 (Troubleshooting & Ops Retrospective)

본 문서는 **ARATEL** 플랫폼(Backend, Web, Mobile) 개발 과정에서 발생한 핵심 네트워크/인프라/DB 문제의 **원인과 해결 방법, 방지책**을 기록하여 향후 개발 및 운영 시 재발을 방지하기 위한 가이드입니다.

---

## 📌 1. Git 대용량 객체 푸시 HTTP 400 에러 (Git HTTPS Push RPC Failure)

### 🚨 현상 (Symptom)
`git push` 실행 시 아래와 같은 오류 메시지와 함께 오브젝트 업로드가 중단됨:
```text
error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
send-pack: unexpected disconnect while reading sideband packet
fatal: the remote end hung up unexpectedly
```

### 🔍 원인 (Root Cause)
Git HTTPS 전송 시 기본 포스트 버퍼(`http.postBuffer`, 기본 1~2MB) 크기가 커밋하려는 패크 파일(Pack Payload, 15. MiB / 6,761개 객체)보다 작아서 버퍼 오버플로우 발생.

### 🛠️ 해결 및 재발 방지책 (Solution)
1. **Git HTTP 버퍼 확장 (500MB)**:
   ```bash
   git config http.postBuffer 524288000
   git config http.version HTTP/1.1
   ```
2. **대안 (SSH 전송)**:
   HTTPS 대신 SSH URL(`git@github.com:gomjunho/aratel.git`)로 변경 시 HTTP 버퍼 제한 없이 대용량 가용.

---

## 📌 2. 모바일 SSL 인증서 & HTTP Cleartext 차단 (Handshake Exception & Silent Block)

### 🚨 현상 (Symptom)
- Flutter 앱에서 통신 시 `HandshakeException: OS Error: CERTIFICATE_VERIFY_FAILED` 예외 발생.
- 또는 에러 없이 API 요청이 무한 대기(Pending) 상태로 응답을 받지 못함.

### 🔍 원인 (Root Cause)
1. **SSL 검증**: Flutter의 `HttpClient`는 로컬 개발용 사설 SSL 인증서를 기본 거부함.
2. **Android Cleartext (HTTP) 차단**: Android 9.0+ (API 28+)부터 보안 정책으로 암호화되지 않은 `http://` 통신을 OS 레벨에서 기본 차단함.
3. **Rails 8 `config.hosts`**: Rails 8의 DNS Spoofing Protection으로 인해 허용되지 않은 Host(`10.0.2.2`) 접근 시 응답 묵인 차단.

### 🛠️ 해결 및 재발 방지책 (Solution)
1. **Flutter 개발용 SSL Bypass (`mobile/lib/main.dart`)**:
   ```dart
   class DevHttpOverrides extends HttpOverrides {
     @override
     HttpClient createHttpClient(SecurityContext? context) {
       return super.createHttpClient(context)
         ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
     }
   }
   void main() {
     HttpOverrides.global = DevHttpOverrides();
     runApp(const AratelApp());
   }
   ```
2. **Android Cleartext 및 인터넷 권한 허용 (`mobile/android/app/src/main/AndroidManifest.xml`)**:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <application android:usesCleartextTraffic="true">
   ```
3. **Rails 8 개발 환경 Host 차단 해제 (`config/environments/development.rb`)**:
   ```ruby
   config.hosts.clear
   ```

---

## 📌 3. 실물 단말기(갤럭시 `SM S928N`) 루프백 주소 불일치 (ADB Reverse Port Forwarding)

### 🚨 현상 (Symptom)
안드로이드 에뮬레이터에서는 통신이 잘 되나, USB/Wi-Fi로 연결된 실물 스마트폰에서는 서버 응답이 오지 않음.

### 🔍 원인 (Root Cause)
`10.0.2.2` IP는 **안드로이드 스튜디오 Virtual 에뮬레이터 전용 루프백** 주소입니다. 실물 스마트폰에서는 `10.0.2.2`나 `localhost`가 맥북으로 연결되지 않고 스마트폰 자체를 가리킴.

### 🛠️ 해결 및 재발 방지책 (Solution)
1. **ADB Reverse Port Forwarding (권장)**:
   스마트폰 연결 후 맥북 터미널에서 3000번 포트를 맥북과 포워딩 연결:
   ```bash
   adb reverse tcp:3000 tcp:3000
   ```
2. **`ApiConfig` 자동 대응 (`mobile/lib/config/api_config.dart`)**:
   ```dart
   class ApiConfig {
     static String get defaultBaseUrl {
       const envUrl = String.fromEnvironment('BASE_URL');
       if (envUrl.isNotEmpty) return envUrl;
       if (Platform.isAndroid) return 'http://127.0.0.1:3000'; // ADB Reverse 이용
       return 'http://127.0.0.1:3000';
     }
   }
   ```

---

## 📌 4. Mono-Repo 환경 Web과 Mobile의 DB 파편화 (Shared SQLite Storage)

### 🚨 현상 (Symptom)
웹(`http://localhost:3000`)에서 디에이치 방배 소속으로 작성한 게시글이 모바일 앱 화면에는 노출되지 않음.

### 🔍 원인 (Root Cause)
`/web`과 `/backend`가 각각 별도의 레일즈 프로젝트로 구성되어 있어, `database.yml`의 `storage/development.sqlite3` 설정이 두 개의 독립된 SQLite DB 파일(`web/storage/...` vs `backend/storage/...`)을 각각 가리킴.

### 🛠️ 해결 및 재발 방지책 (Solution)
1. **통합 공유 DB 디렉터리 구축 (`/shared_storage`)**:
   프로젝트 루트 아래 `shared_storage` 폴더 생성.
2. **`database.yml` 통합 수정 (`backend` 및 `web`)**:
   ```yaml
   development:
     <<: *default
     database: <%= ENV.fetch("SHARED_DB_PATH", Rails.root.join("../shared_storage/development.sqlite3").to_s) %>
   ```
3. **결과**: Web과 Mobile이 100% 동일한 SQLite DB 데이터를 동기화하여 실시간 데이터 일치 보장.

---

> [!TIP]
> **신규 개발자 체크리스트**:
> - [ ] `adb reverse tcp:3000 tcp:3000` 터미널 명령어 실행 여부 확인
> - [ ] `bin/rails server -b 0.0.0.0` 바인딩 옵션 확인
> - [ ] `shared_storage/development.sqlite3` DB 파일 권한 및 공유 확인
