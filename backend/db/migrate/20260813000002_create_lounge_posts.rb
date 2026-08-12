class CreateLoungePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :lounge_posts do |t|
      t.string :post_id, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :anonymous_nickname, default: "은밀한 자산가 42"
      t.string :verified_badge, default: "VERIFIED_OWNER"
      t.string :tier, default: "DIAMOND"
      t.string :complex_name, default: "디에이치 방배"
      t.text :content_encrypted, default: "EncryptedBodyPayload..."
      t.boolean :is_diamond_weighted, default: true
      t.integer :trust_score, default: 98
      t.boolean :clean_signal_verified, default: true
      t.integer :earned_points, default: 50
      t.string :status, default: "PUBLISHED"

      t.timestamps
    end

    add_index :lounge_posts, :post_id, unique: true
  end
end
