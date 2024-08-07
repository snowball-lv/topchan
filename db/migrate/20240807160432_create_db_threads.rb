class CreateDbThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :db_threads do |t|
      t.integer :no
      t.timestamp :last_modified
      t.references :db_board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
