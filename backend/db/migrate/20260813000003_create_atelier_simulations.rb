class CreateAtelierSimulations < ActiveRecord::Migration[8.0]
  def change
    create_table :atelier_simulations do |t|
      t.string :simulation_id, null: false
      t.string :flat_map_id, null: false
      t.text :placed_items
      t.boolean :club_deal_triggered, default: true
      t.string :club_deal_id, default: "deal_552"

      t.timestamps
    end

    add_index :atelier_simulations, :simulation_id, unique: true
  end
end
