class CreateEpics25Tables < ActiveRecord::Migration[8.0]
  def change
    create_table :lounge_posts do |t|
      t.string :post_id, null: false
      t.string :anonymous_nickname
      t.string :verified_badge, default: "VERIFIED_OWNER"
      t.string :tier, default: "DIAMOND"
      t.string :complex_name, default: "디에이치 방배"
      t.string :title
      t.text :content_encrypted
      t.boolean :is_diamond_weighted, default: true
      t.integer :trust_score, default: 98
      t.boolean :clean_signal_verified, default: true
      t.integer :earned_points, default: 50
      t.string :status, default: "PUBLISHED"

      t.timestamps
    end
    add_index :lounge_posts, :post_id, unique: true

    create_table :furniture_catalogs do |t|
      t.string :furniture_id, null: false
      t.string :brand
      t.string :name
      t.string :model_3d_url
      t.integer :price
      t.integer :stock

      t.timestamps
    end
    add_index :furniture_catalogs, :furniture_id, unique: true

    create_table :furniture_simulations do |t|
      t.string :simulation_id, null: false
      t.string :flat_map_id
      t.text :placed_items
      t.boolean :club_deal_triggered, default: true
      t.string :club_deal_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :furniture_simulations, :simulation_id, unique: true

    create_table :club_deals do |t|
      t.string :deal_id, null: false
      t.string :brand
      t.string :item_name
      t.integer :original_price, limit: 8
      t.integer :deal_price, limit: 8
      t.integer :point_discount_limit
      t.integer :min_participants
      t.integer :current_participants
      t.string :status, default: "OPEN"

      t.timestamps
    end
    add_index :club_deals, :deal_id, unique: true

    create_table :club_deal_orders do |t|
      t.string :order_id, null: false
      t.string :club_deal_id
      t.references :user, foreign_key: true
      t.integer :used_points
      t.integer :cash_amount, limit: 8
      t.string :status, default: "ORDER_PLACED"
      t.integer :remaining_points

      t.timestamps
    end
    add_index :club_deal_orders, :order_id, unique: true

    create_table :concierge_reservations do |t|
      t.string :reservation_id, null: false
      t.references :user, foreign_key: true
      t.string :service_type
      t.string :preferred_date
      t.text :notes
      t.string :status, default: "CONFIRMED"
      t.string :assigned_consultant

      t.timestamps
    end
    add_index :concierge_reservations, :reservation_id, unique: true

    create_table :real_estate_transactions do |t|
      t.string :complex_name, default: "디에이치 방배"
      t.integer :floor
      t.integer :price, limit: 8
      t.string :deal_date

      t.timestamps
    end

    create_table :art_docents do |t|
      t.string :title
      t.string :audio_url
      t.text :description

      t.timestamps
    end

    create_table :facility_statuses do |t|
      t.string :facility_name
      t.string :crowd_level
      t.integer :active_reservations

      t.timestamps
    end
  end
end
