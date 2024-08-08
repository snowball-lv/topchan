class CreateDbReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :db_references do |t|
      t.references :post, null: false, foreign_key: { to_table: :db_posts }
      t.references :ref, null: false, foreign_key: { to_table: :db_posts }

      t.timestamps
    end
  end
end
