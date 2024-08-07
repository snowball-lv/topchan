class CreateDbPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :db_posts do |t|
      t.integer :no
      t.references :db_thread, null: false, foreign_key: true

      t.timestamps
    end
  end
end
