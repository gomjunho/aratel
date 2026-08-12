class CreateEpic1Tables < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :birth_date
      t.string :verification_token
      t.datetime :verified_identity_at
      t.string :complex_name
      t.string :building_number
      t.string :unit_number
      t.integer :ownership_percentage, default: 0
      t.string :badge, default: "UNVERIFIED"
      t.string :tier, default: "BRONZE"
      t.text :badges_list, default: "[]"
      t.boolean :screen_capture_prevented, default: true
      t.boolean :privacy_masked, default: true

      t.timestamps
    end

    create_table :delegated_access_requests do |t|
      t.string :delegation_id, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true
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
      t.references :user, null: false, foreign_key: true
      t.string :evidence_type, null: false
      t.string :document_url, null: false
      t.string :instagram_handle
      t.string :referral_code
      t.string :status, default: "UNDER_REVIEW"
      t.string :target_tier, default: "DIAMOND"
      t.datetime :submitted_at
      t.datetime :reviewed_at
      t.text :admin_notes

      t.timestamps
    end
  end
end
