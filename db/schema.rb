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

ActiveRecord::Schema.define(version: 2019_07_09_155025) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appliances", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.float "power"
    t.float "power_factor"
    t.float "starting_coefficient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.string "current_type"
    t.bigint "use_id"
    t.string "hourly_rate_0"
    t.string "hourly_rate_1"
    t.string "hourly_rate_2"
    t.string "hourly_rate_3"
    t.string "hourly_rate_4"
    t.string "hourly_rate_5"
    t.string "hourly_rate_6"
    t.string "hourly_rate_7"
    t.string "hourly_rate_8"
    t.string "hourly_rate_9"
    t.string "hourly_rate_10"
    t.string "hourly_rate_11"
    t.string "hourly_rate_12"
    t.string "hourly_rate_13"
    t.string "hourly_rate_14"
    t.string "hourly_rate_15"
    t.string "hourly_rate_16"
    t.string "hourly_rate_17"
    t.string "hourly_rate_18"
    t.string "hourly_rate_19"
    t.string "hourly_rate_20"
    t.string "hourly_rate_21"
    t.string "hourly_rate_22"
    t.string "hourly_rate_23"
    t.string "energy_grade"
    t.integer "voltage_min"
    t.integer "voltage_max"
    t.boolean "frequency_fifty_hz"
    t.boolean "frequency_sixty_hz"
    t.index ["use_id"], name: "index_appliances_on_use_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "supply_mode"
    t.string "supply_current_type"
    t.integer "supply_voltage"
    t.string "load_current_type"
    t.integer "load_voltage_min"
    t.integer "load_voltage_max"
    t.string "frequency"
    t.string "solar_panel_power"
    t.string "battery_technology"
    t.string "battery_voltage"
    t.string "battery_capacity"
    t.boolean "distribution"
  end

  create_table "sources", force: :cascade do |t|
    t.string "supplier"
    t.datetime "issued_at"
    t.text "details"
    t.string "country_code"
    t.string "city"
    t.integer "price_cents"
    t.string "currency"
    t.bigint "appliance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount_rate", default: 0
    t.index ["appliance_id"], name: "index_sources_on_appliance_id"
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
    t.boolean "approved", default: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "uses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hourly_rate_0"
    t.string "hourly_rate_1"
    t.string "hourly_rate_2"
    t.string "hourly_rate_3"
    t.string "hourly_rate_4"
    t.string "hourly_rate_5"
    t.string "hourly_rate_6"
    t.string "hourly_rate_7"
    t.string "hourly_rate_8"
    t.string "hourly_rate_9"
    t.string "hourly_rate_10"
    t.string "hourly_rate_11"
    t.string "hourly_rate_12"
    t.string "hourly_rate_13"
    t.string "hourly_rate_14"
    t.string "hourly_rate_15"
    t.string "hourly_rate_16"
    t.string "hourly_rate_17"
    t.string "hourly_rate_18"
    t.string "hourly_rate_19"
    t.string "hourly_rate_20"
    t.string "hourly_rate_21"
    t.string "hourly_rate_22"
    t.string "hourly_rate_23"
  end

  add_foreign_key "appliances", "uses"
  add_foreign_key "sources", "appliances"
end
