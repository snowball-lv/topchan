class AddJsonToDbPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :db_posts, :json, :text
  end
end
