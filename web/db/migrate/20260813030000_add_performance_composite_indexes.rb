class AddPerformanceCompositeIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :community_posts, [:board_type, :complex_name, :created_at], name: "idx_comm_posts_board_complex_created" unless index_exists?(:community_posts, [:board_type, :complex_name, :created_at])
    add_index :lounge_posts, :created_at unless index_exists?(:lounge_posts, :created_at)
  end
end
