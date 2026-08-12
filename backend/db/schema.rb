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

ActiveRecord::Schema[8.0].define(version: 2026_08_13_000002) do
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
