class CreateEpic1VerificationTables < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_id, null: false, index: { unique: true }
      t.string :name
      t.string :phone_number
      t.string :birth_date
      t.string :tier, default: "BRONZE", null: false
      t.text :badges, default: "[]"
      t.string :complex_name
      t.string :building_number
      t.string :unit_number
      t.string :role, default: "USER"
      t.boolean :screen_capture_prevented, default: true
      t.boolean :privacy_masked, default: true

      t.timestamps
    end

    create_table :identity_verifications do |t|
      t.string :verification_token, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :phone_number, null: false
      t.string :birth_date, null: false
      t.string :masked_name
      t.string :status, default: "success"
      t.datetime :verified_at

      t.timestamps
    end

    create_table :trust_api_syncs do |t|
      t.string :verification_token, null: false, index: true
      t.string :complex_name, null: false
      t.string :building_number, null: false
      t.string :unit_number, null: false
      t.string :status, default: "VERIFIED"
      t.string :owner_name_masked
      t.integer :ownership_percentage, default: 100
      t.string :badge, default: "VERIFIED_OWNER"
      t.string :assigned_tier, default: "GOLD"
      t.datetime :verified_at

      t.timestamps
    end

    create_table :delegated_accesses do |t|
      t.string :delegation_id, null: false, index: { unique: true }
      t.string :relationship, null: false
      t.string :document_url, null: false
      t.string :status, default: "PENDING_OWNER_APPROVAL"
      t.string :granted_badge
      t.string :role
      t.datetime :requested_at

      t.timestamps
    end

    create_table :tier_evidences do |t|
      t.string :submission_id, null: false, index: { unique: true }
      t.string :evidence_type, null: false
      t.string :document_url, null: false
      t.string :instagram_handle
      t.string :referral_code
      t.string :status, default: "UNDER_REVIEW"
      t.string :target_tier, default: "DIAMOND"
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
