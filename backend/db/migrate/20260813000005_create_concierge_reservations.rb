class CreateConciergeReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :concierge_reservations do |t|
      t.string :reservation_id, null: false
      t.string :service_type, null: false
      t.string :preferred_date
      t.text :notes
      t.string :status, default: "CONFIRMED"
      t.string :assigned_consultant

      t.timestamps
    end

    add_index :concierge_reservations, :reservation_id, unique: true
  end
end
