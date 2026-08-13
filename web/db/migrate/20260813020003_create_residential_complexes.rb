class CreateResidentialComplexes < ActiveRecord::Migration[8.0]
  def change
    create_table :residential_complexes do |t|
      t.string :name
      t.string :primary_color
      t.string :secondary_color
      t.string :accent_color
      t.string :banner_title
      t.text :description

      t.timestamps
    end
  end
end
