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

ActiveRecord::Schema.define(version: 2019_06_06_110928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appliances", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "voltage"
    t.float "power"
    t.float "power_factor"
    t.float "starting_coefficient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.string "current_type"
    t.bigint "use_id"
    t.string "hourly_rate_0", default: "0.0"
    t.string "hourly_rate_1", default: "0.0"
    t.string "hourly_rate_2", default: "0.0"
    t.string "hourly_rate_3", default: "0.0"
    t.string "hourly_rate_4", default: "0.0"
    t.string "hourly_rate_5", default: "0.0"
    t.string "hourly_rate_6", default: "0.0"
    t.string "hourly_rate_7", default: "0.0"
    t.string "hourly_rate_8", default: "0.0"
    t.string "hourly_rate_9", default: "0.0"
    t.string "hourly_rate_10", default: "0.0"
    t.string "hourly_rate_11", default: "0.0"
    t.string "hourly_rate_12", default: "0.0"
    t.string "hourly_rate_13", default: "0.0"
    t.string "hourly_rate_14", default: "0.0"
    t.string "hourly_rate_15", default: "0.0"
    t.string "hourly_rate_16", default: "0.0"
    t.string "hourly_rate_17", default: "0.0"
    t.string "hourly_rate_18", default: "0.0"
    t.string "hourly_rate_19", default: "0.0"
    t.string "hourly_rate_20", default: "0.0"
    t.string "hourly_rate_21", default: "0.0"
    t.string "hourly_rate_22", default: "0.0"
    t.string "hourly_rate_23", default: "0.0"
    t.index ["use_id"], name: "index_appliances_on_use_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "uses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appliances", "uses"
  add_foreign_key "projects", "users"
end
