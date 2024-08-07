class CreateDbBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :db_boards do |t|
      t.string :board
      t.string :title
      t.text :meta_description

      t.timestamps
    end
  end
end
