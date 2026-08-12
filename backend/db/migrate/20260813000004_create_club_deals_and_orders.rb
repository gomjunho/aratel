class CreateClubDealsAndOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :club_deals do |t|
      t.string :deal_id, null: false
      t.string :brand, null: false
      t.string :item_name, null: false
      t.integer :original_price, null: false
      t.integer :deal_price, null: false
      t.integer :point_discount_limit, default: 1000000
      t.integer :min_participants, default: 5
      t.integer :current_participants, default: 3
      t.string :status, default: "OPEN"

      t.timestamps
    end

    add_index :club_deals, :deal_id, unique: true

    create_table :club_deal_orders do |t|
      t.string :order_id, null: false
      t.string :club_deal_id, null: false
      t.integer :used_points, null: false
      t.integer :cash_amount, null: false
      t.string :status, default: "ORDER_PLACED"
      t.integer :remaining_points, default: 450000

      t.timestamps
    end

    add_index :club_deal_orders, :order_id, unique: true
  end
end
