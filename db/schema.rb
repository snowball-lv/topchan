# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_14_175603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "db_boards", force: :cascade do |t|
    t.string "board"
    t.string "title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "db_posts", force: :cascade do |t|
    t.integer "no"
    t.integer "db_thread_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "json"
    t.boolean "processed", default: false
    t.index ["db_thread_id"], name: "index_db_posts_on_db_thread_id"
  end

  create_table "db_references", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "ref_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_db_references_on_post_id"
    t.index ["ref_id"], name: "index_db_references_on_ref_id"
  end

  create_table "db_threads", force: :cascade do |t|
    t.integer "no"
    t.datetime "last_modified"
    t.integer "db_board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["db_board_id"], name: "index_db_threads_on_db_board_id"
  end

  add_foreign_key "db_posts", "db_threads"
  add_foreign_key "db_references", "db_posts", column: "post_id"
  add_foreign_key "db_references", "db_posts", column: "ref_id"
  add_foreign_key "db_threads", "db_boards"
end
