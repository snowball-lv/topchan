class AddProcessedToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :db_posts, :processed, :boolean, default: false
  end
end
