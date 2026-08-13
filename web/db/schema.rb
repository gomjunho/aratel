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

ActiveRecord::Schema[8.0].define(version: 2026_08_13_020004) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "art_docents", force: :cascade do |t|
    t.string "title"
    t.string "audio_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "club_deal_orders", force: :cascade do |t|
    t.string "order_id", null: false
    t.string "club_deal_id"
    t.integer "user_id"
    t.integer "used_points"
    t.integer "cash_amount", limit: 8
    t.string "status", default: "ORDER_PLACED"
    t.integer "remaining_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_club_deal_orders_on_order_id", unique: true
    t.index ["user_id"], name: "index_club_deal_orders_on_user_id"
  end

  create_table "club_deals", force: :cascade do |t|
    t.string "deal_id", null: false
    t.string "brand"
    t.string "item_name"
    t.integer "original_price", limit: 8
    t.integer "deal_price", limit: 8
    t.integer "point_discount_limit"
    t.integer "min_participants"
    t.integer "current_participants"
    t.string "status", default: "OPEN"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_club_deals_on_deal_id", unique: true
  end

  create_table "community_posts", force: :cascade do |t|
    t.string "board_type"
    t.string "complex_name"
    t.string "building_number"
    t.string "nickname"
    t.boolean "is_anonymous"
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concierge_reservations", force: :cascade do |t|
    t.string "reservation_id", null: false
    t.integer "user_id"
    t.string "service_type"
    t.string "preferred_date"
    t.text "notes"
    t.string "status", default: "CONFIRMED"
    t.string "assigned_consultant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_concierge_reservations_on_reservation_id", unique: true
    t.index ["user_id"], name: "index_concierge_reservations_on_user_id"
  end

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

  create_table "facility_statuses", force: :cascade do |t|
    t.string "facility_name"
    t.string "crowd_level"
    t.integer "active_reservations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "furniture_catalogs", force: :cascade do |t|
    t.string "furniture_id", null: false
    t.string "brand"
    t.string "name"
    t.string "model_3d_url"
    t.integer "price"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["furniture_id"], name: "index_furniture_catalogs_on_furniture_id", unique: true
  end

  create_table "furniture_simulations", force: :cascade do |t|
    t.string "simulation_id", null: false
    t.string "flat_map_id"
    t.text "placed_items"
    t.boolean "club_deal_triggered", default: true
    t.string "club_deal_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["simulation_id"], name: "index_furniture_simulations_on_simulation_id", unique: true
    t.index ["user_id"], name: "index_furniture_simulations_on_user_id"
  end

  create_table "lounge_posts", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "anonymous_nickname"
    t.string "verified_badge", default: "VERIFIED_OWNER"
    t.string "tier", default: "DIAMOND"
    t.string "complex_name", default: "디에이치 방배"
    t.string "title"
    t.text "content_encrypted"
    t.boolean "is_diamond_weighted", default: true
    t.integer "trust_score", default: 98
    t.boolean "clean_signal_verified", default: true
    t.integer "earned_points", default: 50
    t.string "status", default: "PUBLISHED"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_lounge_posts_on_post_id", unique: true
  end

  create_table "real_estate_transactions", force: :cascade do |t|
    t.string "complex_name", default: "디에이치 방배"
    t.integer "floor"
    t.integer "price", limit: 8
    t.string "deal_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "residential_complexes", force: :cascade do |t|
    t.string "name"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "accent_color"
    t.string "banner_title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "club_deal_orders", "users"
  add_foreign_key "concierge_reservations", "users"
  add_foreign_key "delegated_access_requests", "users"
  add_foreign_key "furniture_simulations", "users"
  add_foreign_key "tier_evidences", "users"
end
