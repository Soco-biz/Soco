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

ActiveRecord::Schema.define(version: 20180502023443) do

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "contents", null: false
    t.integer "good", default: 0
    t.integer "bad", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "rooms_id"
    t.float "latitude", limit: 24, null: false
    t.float "longitude", limit: 24, null: false
    t.text "image"
    t.index ["rooms_id"], name: "index_posts_on_rooms_id"
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.float "latitude", limit: 24, null: false
    t.float "longitude", limit: 24, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "image"
    t.string "description"
  end

  add_foreign_key "posts", "rooms", column: "rooms_id"
end
