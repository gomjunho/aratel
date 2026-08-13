class AddPerformanceCompositeIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :lounge_posts, :created_at unless index_exists?(:lounge_posts, :created_at)
  end
end
