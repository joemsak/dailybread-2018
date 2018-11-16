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

ActiveRecord::Schema.define(version: 2018_11_16_015846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "v1_bills", force: :cascade do |t|
    t.integer "amount", null: false
    t.string "name", null: false
    t.integer "pay_period", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_v1_bills_on_user_id"
  end

  create_table "v1_expenses", force: :cascade do |t|
    t.string "category", null: false
    t.string "name"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "made_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_v1_expenses_on_user_id"
  end

  create_table "v1_incomes", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_v1_incomes_on_user_id"
  end

  create_table "v1_users", force: :cascade do |t|
    t.string "email", null: false
    t.integer "status", default: 0, null: false
    t.string "magic_signin_token", null: false
    t.datetime "magic_signin_token_expires_at"
    t.string "email_confirmation_token", null: false
    t.datetime "email_confirmation_token_expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "v1_bills", "v1_users", column: "user_id"
  add_foreign_key "v1_expenses", "v1_users", column: "user_id"
  add_foreign_key "v1_incomes", "v1_users", column: "user_id"
end
