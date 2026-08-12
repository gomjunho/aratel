# 📄 Epics 2 ~ 5 Comprehensive API Contract Specification

본 문서는 ARATEL의 Epic 2(소통), Epic 3(소비), Epic 4(인사이트/데이터), Epic 5(UI/UX)에 대한 모듈 간 인터페이스 합의 규격서입니다.

---

## 💬 Epic 2: 소통 & 디지털 웰컴 홈 (Communication)

### 1. 🏠 디지털 웰컴 홈 & 조경 아트 도슨트 조회
* **Endpoint**: `GET /api/v1/home/welcome`
* **Response (200 OK)**:
  ```json
  {
    "complex_name": "디에이치 방배",
    "art_docents": [
      {
        "title": "더샵 갤러리 '조경과 빛'",
        "audio_url": "https://storage.aratel.com/audio/docent1.mp3",
        "description": "단지 중앙 정원에 위치한 현대 미술 조형물에 대한 설명입니다."
      }
    ],
    "facilities_status": [
      { "facility_name": "스카이라운지", "crowd_level": "NORMAL", "active_reservations": 12 },
      { "facility_name": "피트니스 센타", "crowd_level": "CROWDED", "active_reservations": 45 },
      { "facility_name": "사우나", "crowd_level": "SMOOTH", "active_reservations": 8 }
    ],
    "smart_home_state": {
      "lighting": "ON",
      "hvac_temperature": 22.5,
      "ventilation": "AUTO"
    }
  }
  ```

---

### 2. 🤖 AI 에이전트 대화 및 자연어 제어 (Gemini Function Calling)
* **Endpoint**: `POST /api/v1/ai/agent_dialogue`
* **Request**:
  ```json
  {
    "message": "라운지 조식 2명 예약해줘"
  }
  ```
* **Response (200 OK)**:
  ```json
  {
    "reply": "네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.",
    "action_executed": "RESERVE_BREAKFAST",
    "reservation_details": {
      "facility": "스카이라운지",
      "party_size": 2,
      "status": "CONFIRMED"
    }
  }
  ```

---

### 3. 🔐 암호화 익명 라운지 게시글 피드 조회 & 작성 (Exclusive Social)
* **Endpoint**: `GET /api/v1/lounge/posts`
* **Response (200 OK)**:
  ```json
  {
    "posts": [
      {
        "id": "post_7001",
        "anonymous_nickname": "은밀한 자산가 42",
        "verified_badge": "VERIFIED_OWNER",
        "tier": "DIAMOND",
        "complex_name": "디에이치 방배",
        "title": "2026 하반기 종합소득세 및 증여 절세 노하우",
        "content_encrypted": "EncryptedBodyPayload...",
        "is_diamond_weighted": true,
        "trust_score": 98,
        "created_at": "2026-08-13T01:50:00Z"
      }
    ]
  }
  ```

* **Endpoint**: `POST /api/v1/lounge/posts`
* **Request**:
  ```json
  {
    "title": "단지 내 스카이라운지 조식 이용 관련 제안",
    "content": "조식 시간대를 10시까지 연장하는 건에 대해 논의해봅시다."
  }
  ```
* **Response (201 Created)**:
  ```json
  {
    "id": "post_7002",
    "clean_signal_verified": true,
    "earned_points": 50,
    "status": "PUBLISHED"
  }
  ```

---

## 🛍️ Epic 3: 소비 & AI 아뜰리에 & VIP 컨시어지 (Consumption)

### 4. 🛋️ AI 아뜰리에 3D 평면도 & 명품 가구 시뮬레이션
* **Endpoint**: `GET /api/v1/atelier/flat_maps`
* **Response (200 OK)**:
  ```json
  {
    "flat_map_url": "https://storage.aratel.com/3d/dh_bangbae_84a.gltf",
    "furniture_catalog": [
      {
        "id": "furn_101",
        "brand": "B&B Italia",
        "name": "Camaleonda Sofa",
        "model_3d_url": "https://storage.aratel.com/3d/sofa_bb.gltf",
        "price": 18500000,
        "stock": 3
      }
    ]
  }
  ```

* **Endpoint**: `POST /api/v1/atelier/simulations`
* **Request**:
  ```json
  {
    "flat_map_id": "flat_84a",
    "placed_items": [
      { "furniture_id": "furn_101", "position": [1.2, 0.0, 3.4], "rotation": [0, 90, 0] }
    ]
  }
  ```
* **Response (201 Created)**:
  ```json
  {
    "simulation_id": "sim_8812",
    "club_deal_triggered": true,
    "club_deal_id": "deal_552"
  }
  ```

---

### 5. 🏷️ 수입 브랜드 '클럽 딜 (Club Deal)' 프라이빗 공동 오더
* **Endpoint**: `GET /api/v1/club_deals`
* **Response (200 OK)**:
  ```json
  {
    "club_deals": [
      {
        "id": "deal_552",
        "brand": "B&B Italia",
        "item_name": "Camaleonda Sofa VVIP Club Deal",
        "original_price": 18500000,
        "deal_price": 14200000,
        "point_discount_limit": 1000000,
        "min_participants": 5,
        "current_participants": 3,
        "status": "OPEN"
      }
    ]
  }
  ```

* **Endpoint**: `POST /api/v1/club_deals/:id/order`
* **Request**:
  ```json
  {
    "used_points": 500000,
    "cash_amount": 13700000
  }
  ```
* **Response (201 Created)**:
  ```json
  {
    "order_id": "ord_9901",
    "status": "ORDER_PLACED",
    "remaining_points": 450000
  }
  ```

---

### 6. 🛎️ VIP 컨시어지 & 웰니스 서비스 예약
* **Endpoint**: `POST /api/v1/concierge/reservations`
* **Request**:
  ```json
  {
    "service_type": "WOORI_TWO_CHAIRS", // "LUXURY_PEST_CONTROL", "HEALTH_CHECKUP", "ART_SUBSCRIPTION"
    "preferred_date": "2026-08-20",
    "notes": "자산 증여 및 외환 법률 상담 희망"
  }
  ```
* **Response (201 Created)**:
  ```json
  {
    "reservation_id": "res_7710",
    "service_type": "WOORI_TWO_CHAIRS",
    "status": "CONFIRMED",
    "assigned_consultant": "우리은행 TWO CHAIRS 수석 자산관리사"
  }
  ```

---

## 📊 Epic 4: 아실 기반 실거래가 층수 산점도 & 입주 물량 인사이트 (Insights)

### 7. 📈 층수별 실거래가 산점도 & 주변 공급 물량 독성 분석
* **Endpoint**: `GET /api/v1/insights/transactions`
* **Response (200 OK)**:
  ```json
  {
    "complex_name": "디에이치 방배",
    "transactions": [
      { "floor": 15, "price": 2850000000, "deal_date": "2026-07-15" },
      { "floor": 3, "price": 2510000000, "deal_date": "2026-07-10" }
    ],
    "supply_gas_index": {
      "risk_level": "LOW",
      "upcoming_supply_units": 450,
      "analysis_summary": "향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다."
    }
  }
  ```
