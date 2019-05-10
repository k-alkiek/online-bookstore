# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "AUTHOR", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "Author_name", limit: 45, null: false
  end

  create_table "BOOK", primary_key: "ISBN", id: :string, limit: 17, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 120, null: false
    t.string "category", limit: 9, null: false
    t.decimal "selling_price", precision: 10, scale: 2, null: false
    t.integer "Minimum_threshold", null: false
    t.integer "Available_copies_count", null: false
    t.string "PUBLISHER_Name", limit: 45, null: false
    t.date "publish_year", null: false
    t.index ["PUBLISHER_Name"], name: "fk_BOOK_PUBLISHER1_idx"
    t.index ["title"], name: "title_index"
  end

  create_table "BOOK_AUTHOR", primary_key: ["BOOK_ISBN", "AUTHOR_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "BOOK_ISBN", limit: 17, null: false
    t.integer "AUTHOR_id", null: false
    t.index ["AUTHOR_id"], name: "fk_BOOK_has_AUTHOR_AUTHOR1_idx"
    t.index ["BOOK_ISBN"], name: "fk_BOOK_has_AUTHOR_BOOK1_idx"
  end

  create_table "ORDER", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date_submitted", null: false
    t.date "estimated_arrival_date"
    t.boolean "confirmed", default: false, null: false
    t.string "BOOK_ISBN", limit: 17, null: false
    t.integer "quantity", null: false
    t.index ["BOOK_ISBN"], name: "fk_ORDER_BOOK_idx"
  end

  create_table "PUBLISHER", primary_key: "Name", id: :string, limit: 45, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "address", limit: 150, null: false
    t.string "telephone", limit: 45, null: false
  end

  create_table "PURCHASE", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "User_id", null: false
    t.string "BOOK_ISBN", limit: 17, null: false
    t.integer "No_of_copies", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.date "date_of_purchase", null: false
    t.index ["BOOK_ISBN"], name: "fk_User_has_BOOK_BOOK1_idx"
    t.index ["User_id"], name: "fk_User_has_BOOK_User1_idx"
  end

  create_table "User", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", limit: 120, null: false
    t.string "password", limit: 100, null: false
    t.string "first_name", limit: 45, null: false
    t.string "last_name", limit: 45, null: false
    t.string "phone", limit: 45, null: false
    t.string "address", limit: 120, null: false
    t.boolean "isManager", default: false, null: false
    t.date "date_joined", null: false
    t.index ["email"], name: "email_UNIQUE", unique: true
  end

  add_foreign_key "BOOK", "PUBLISHER", column: "PUBLISHER_Name", primary_key: "Name", name: "fk_BOOK_PUBLISHER1", on_update: :cascade
  add_foreign_key "BOOK_AUTHOR", "AUTHOR", name: "fk_BOOK_has_AUTHOR_AUTHOR1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "BOOK_AUTHOR", "BOOK", column: "BOOK_ISBN", primary_key: "ISBN", name: "fk_BOOK_has_AUTHOR_BOOK1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "ORDER", "BOOK", column: "BOOK_ISBN", primary_key: "ISBN", name: "fk_ORDER_BOOK", on_update: :cascade
  add_foreign_key "PURCHASE", "BOOK", column: "BOOK_ISBN", primary_key: "ISBN", name: "fk_User_has_BOOK_BOOK1", on_update: :cascade
  add_foreign_key "PURCHASE", "User", name: "fk_User_has_BOOK_User1", on_update: :cascade
end
