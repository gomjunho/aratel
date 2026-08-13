class CreateCommunityPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :community_posts do |t|
      t.string :board_type
      t.string :complex_name
      t.string :building_number
      t.string :nickname
      t.boolean :is_anonymous
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
