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

ActiveRecord::Schema[8.0].define(version: 2026_08_13_013300) do
  create_table "delegated_access_requests", force: :cascade do |t|
    t.string "delegation_id", null: false
    t.integer "user_id", null: false
    t.string "relationship", null: false
    t.string "document_url", null: false
    t.string "status", default: "PENDING_OWNER_APPROVAL"
    t.string "granted_badge"
    t.string "role"
    t.datetime "requested_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delegation_id"], name: "index_delegated_access_requests_on_delegation_id", unique: true
    t.index ["user_id"], name: "index_delegated_access_requests_on_user_id"
  end

  create_table "tier_evidences", force: :cascade do |t|
    t.string "submission_id", null: false
    t.integer "user_id", null: false
    t.string "evidence_type", null: false
    t.string "document_url", null: false
    t.string "instagram_handle"
    t.string "referral_code"
    t.string "status", default: "UNDER_REVIEW"
    t.string "target_tier", default: "DIAMOND"
    t.datetime "submitted_at"
    t.datetime "reviewed_at"
    t.text "admin_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_tier_evidences_on_submission_id", unique: true
    t.index ["user_id"], name: "index_tier_evidences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number"
    t.string "birth_date"
    t.string "verification_token"
    t.datetime "verified_identity_at"
    t.string "complex_name"
    t.string "building_number"
    t.string "unit_number"
    t.integer "ownership_percentage", default: 0
    t.string "badge", default: "UNVERIFIED"
    t.string "tier", default: "BRONZE"
    t.text "badges_list", default: "[]"
    t.boolean "screen_capture_prevented", default: true
    t.boolean "privacy_masked", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "delegated_access_requests", "users"
  add_foreign_key "tier_evidences", "users"
end
