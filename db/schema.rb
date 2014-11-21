# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141118024715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.boolean  "liked"
    t.boolean  "in_wishlist"
    t.boolean  "clicked_through"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "merchant_id"
    t.string   "sku"
    t.string   "name"
    t.integer  "category_id"
    t.text     "merchant_url"
    t.string   "price"
    t.string   "price_sale"
    t.string   "brand"
    t.string   "color"
    t.string   "gender"
    t.text     "keywords"
    t.text     "image_url50"
    t.text     "image_url400"
    t.integer  "rating"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
  end

end
