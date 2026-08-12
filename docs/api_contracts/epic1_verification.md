# 📄 Epic 1: 인증 & 회원가입 (Verification) API Contract

본 문서는 Epic 1의 `backend`, `web`, `mobile` 모듈 간 인터페이스 합의 규격서입니다.

---

## 🔑 Data Models & Enums

### 1. Membership Tier Enum
```typescript
type MembershipTier = 'DIAMOND' | 'PLATINUM' | 'GOLD' | 'BRONZE';
```

### 2. Badge Type Enum
```typescript
type BadgeType = 'VERIFIED_OWNER' | 'RESIDENT' | 'DIAMOND_BLACK' | 'PLATINUM_SILVER' | 'GOLD_EMBLEM' | 'BRONZE_METALLIC';
```

### 3. Verification Status Enum
```typescript
type VerificationStatus = 'UNVERIFIED' | 'PENDING' | 'VERIFIED' | 'REJECTED';
```

---

## 📡 API Endpoints Specification

### 1. 📱 휴대폰 본인확인 (Identity Verification)
* **Endpoint**: `POST /api/v1/auth/identity_verify`
* **Request**:
  ```json
  {
    "name": "홍길동",
    "phone_number": "01012345678",
    "birth_date": "19800101"
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "status": "success",
    "verification_token": "ver_tok_8f9a2b1c",
    "masked_name": "홍*동",
    "verified_at": "2026-08-13T01:32:00Z"
  }
  ```

---

### 2. 🏛️ 1분 자동 등기부 연동 (Trust API Sync)
* **Endpoint**: `POST /api/v1/verification/trust_api_sync`
* **Request**:
  ```json
  {
    "verification_token": "ver_tok_8f9a2b1c",
    "complex_name": "디에이치 방배",
    "building_number": "101동",
    "unit_number": "1502호"
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "status": "VERIFIED",
    "owner_name_masked": "홍*동",
    "ownership_percentage": 100,
    "badge": "VERIFIED_OWNER",
    "assigned_tier": "GOLD",
    "verified_at": "2026-08-13T01:32:05Z"
  }
  ```

---

### 3. 👥 대리인 및 가족 권한 위임 신청 (Delegated Access Request)
* **Endpoint**: `POST /api/v1/verification/delegated_access`
* **Request**:
  ```json
  {
    "relationship": "FAMILY",
    "document_url": "https://storage.aratel.com/docs/family_rel_123.pdf"
  }
  ```
* **Response (201 Created)**:
  ```json
  {
    "delegation_id": "del_9981",
    "status": "PENDING_OWNER_APPROVAL",
    "requested_at": "2026-08-13T01:32:10Z"
  }
  ```

---

### 4. ✅ 명의자 권한 위임 승인/거절 (Owner Approval)
* **Endpoint**: `POST /api/v1/verification/delegated_access/:id/approve`
* **Request**:
  ```json
  {
    "approved": true
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "delegation_id": "del_9981",
    "status": "APPROVED",
    "granted_badge": "RESIDENT",
    "role": "RESIDENT"
  }
  ```

---

### 5. 💎 VVIP 자산 증빙 제출 (Tier Evidence Submission)
* **Endpoint**: `POST /api/v1/verification/tier_evidence`
* **Request**:
  ```json
  {
    "evidence_type": "INCOME_CERT",
    "document_url": "https://storage.aratel.com/docs/income_2025.pdf",
    "instagram_handle": "@vip_user",
    "referral_code": "DIAMOND_777"
  }
  ```
* **Response (202 Accepted)**:
  ```json
  {
    "submission_id": "sub_4412",
    "status": "UNDER_REVIEW",
    "target_tier": "DIAMOND",
    "submitted_at": "2026-08-13T01:32:15Z"
  }
  ```

---

### 6. 👤 내 자산 인증 및 등급 정보 조회 (Get User Tier & Security Profile)
* **Endpoint**: `GET /api/v1/users/me/tier`
* **Response (200 OK)**:
  ```json
  {
    "user_id": "usr_1001",
    "tier": "DIAMOND",
    "badges": ["VERIFIED_OWNER", "DIAMOND_BLACK"],
    "complex_name": "디에이치 방배",
    "building_unit": "101동 1502호",
    "security_profile": {
      "screen_capture_prevented": true,
      "privacy_masked": true
    }
  }
  ```
