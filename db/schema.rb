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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_113350) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "description"
    t.integer "gutendex_id"
    t.string "download_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.text "cover_url"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "position"
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "reading_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.integer "current_location", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chapter_id", null: false
    t.float "progress_percentage", default: 0.0
    t.datetime "last_read_at"
    t.index ["book_id"], name: "index_reading_progresses_on_book_id"
    t.index ["chapter_id"], name: "index_reading_progresses_on_chapter_id"
    t.index ["user_id"], name: "index_reading_progresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "theme", default: 0
    t.integer "font_size", default: 14
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabularies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "word"
    t.text "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vocabularies_on_user_id"
  end

  add_foreign_key "books", "users"
  add_foreign_key "chapters", "books"
  add_foreign_key "notes", "users"
  add_foreign_key "reading_progresses", "books"
  add_foreign_key "reading_progresses", "chapters"
  add_foreign_key "reading_progresses", "users"
  add_foreign_key "vocabularies", "users"
end
