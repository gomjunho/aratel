# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_08_13_000005) do
  create_table "atelier_simulations", force: :cascade do |t|
    t.string "simulation_id", null: false
    t.string "flat_map_id", null: false
    t.text "placed_items"
    t.boolean "club_deal_triggered", default: true
    t.string "club_deal_id", default: "deal_552"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["simulation_id"], name: "index_atelier_simulations_on_simulation_id", unique: true
  end

  create_table "club_deal_orders", force: :cascade do |t|
    t.string "order_id", null: false
    t.string "club_deal_id", null: false
    t.integer "used_points", null: false
    t.integer "cash_amount", null: false
    t.string "status", default: "ORDER_PLACED"
    t.integer "remaining_points", default: 450000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_club_deal_orders_on_order_id", unique: true
  end

  create_table "club_deals", force: :cascade do |t|
    t.string "deal_id", null: false
    t.string "brand", null: false
    t.string "item_name", null: false
    t.integer "original_price", null: false
    t.integer "deal_price", null: false
    t.integer "point_discount_limit", default: 1000000
    t.integer "min_participants", default: 5
    t.integer "current_participants", default: 3
    t.string "status", default: "OPEN"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_club_deals_on_deal_id", unique: true
  end

  create_table "concierge_reservations", force: :cascade do |t|
    t.string "reservation_id", null: false
    t.string "service_type", null: false
    t.string "preferred_date"
    t.text "notes"
    t.string "status", default: "CONFIRMED"
    t.string "assigned_consultant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_concierge_reservations_on_reservation_id", unique: true
  end

  create_table "delegated_accesses", force: :cascade do |t|
    t.string "delegation_id", null: false
    t.string "relationship", null: false
    t.string "document_url", null: false
    t.string "status", default: "PENDING_OWNER_APPROVAL"
    t.string "granted_badge"
    t.string "role"
    t.datetime "requested_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delegation_id"], name: "index_delegated_accesses_on_delegation_id", unique: true
  end

  create_table "identity_verifications", force: :cascade do |t|
    t.string "verification_token", null: false
    t.string "name", null: false
    t.string "phone_number", null: false
    t.string "birth_date", null: false
    t.string "masked_name"
    t.string "status", default: "success"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["verification_token"], name: "index_identity_verifications_on_verification_token", unique: true
  end

  create_table "lounge_posts", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.string "anonymous_nickname", default: "은밀한 자산가 42"
    t.string "verified_badge", default: "VERIFIED_OWNER"
    t.string "tier", default: "DIAMOND"
    t.string "complex_name", default: "디에이치 방배"
    t.text "content_encrypted", default: "EncryptedBodyPayload..."
    t.boolean "is_diamond_weighted", default: true
    t.integer "trust_score", default: 98
    t.boolean "clean_signal_verified", default: true
    t.integer "earned_points", default: 50
    t.string "status", default: "PUBLISHED"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_lounge_posts_on_post_id", unique: true
  end

  create_table "tier_evidences", force: :cascade do |t|
    t.string "submission_id", null: false
    t.string "evidence_type", null: false
    t.string "document_url", null: false
    t.string "instagram_handle"
    t.string "referral_code"
    t.string "status", default: "UNDER_REVIEW"
    t.string "target_tier", default: "DIAMOND"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_tier_evidences_on_submission_id", unique: true
  end

  create_table "trust_api_syncs", force: :cascade do |t|
    t.string "verification_token", null: false
    t.string "complex_name", null: false
    t.string "building_number", null: false
    t.string "unit_number", null: false
    t.string "status", default: "VERIFIED"
    t.string "owner_name_masked"
    t.integer "ownership_percentage", default: 100
    t.string "badge", default: "VERIFIED_OWNER"
    t.string "assigned_tier", default: "GOLD"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["verification_token"], name: "index_trust_api_syncs_on_verification_token"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "name"
    t.string "phone_number"
    t.string "birth_date"
    t.string "tier", default: "BRONZE", null: false
    t.text "badges", default: "[]"
    t.string "complex_name"
    t.string "building_number"
    t.string "unit_number"
    t.string "role", default: "USER"
    t.boolean "screen_capture_prevented", default: true
    t.boolean "privacy_masked", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end
end
