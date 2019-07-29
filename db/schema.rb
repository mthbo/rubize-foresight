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

ActiveRecord::Schema.define(version: 2019_07_29_110332) do

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

  create_table "batteries", force: :cascade do |t|
    t.string "technology"
    t.integer "dod"
    t.integer "voltage"
    t.integer "capacity"
    t.integer "price_min_cents"
    t.string "currency", default: "eur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "efficiency"
    t.integer "price_max_cents"
  end

  create_table "power_systems", force: :cascade do |t|
    t.string "name"
    t.boolean "ac_out"
    t.integer "power_out_max"
    t.integer "voltage_out_min"
    t.integer "voltage_out_max"
    t.integer "price_min_cents"
    t.string "currency", default: "eur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_max_cents"
    t.string "mppt"
    t.string "inverter"
    t.integer "system_voltage"
    t.integer "power_in_min"
    t.integer "power_in_max"
  end

  create_table "project_appliances", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "appliance_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.index ["appliance_id"], name: "index_project_appliances_on_appliance_id"
    t.index ["project_id"], name: "index_project_appliances_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "voltage_min"
    t.integer "voltage_max"
    t.string "frequency"
    t.time "day_time"
    t.time "night_time"
    t.string "country_code"
    t.string "city"
    t.boolean "current_ac"
    t.boolean "current_dc"
  end

  create_table "solar_panels", force: :cascade do |t|
    t.integer "power"
    t.integer "price_min_cents"
    t.string "currency", default: "eur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "technology"
    t.integer "price_max_cents"
  end

  create_table "solar_systems", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "solar_panel_id"
    t.bigint "battery_id"
    t.bigint "power_system_id"
    t.integer "system_voltage"
    t.boolean "communication"
    t.boolean "distribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "autonomy", default: 1.0
    t.index ["battery_id"], name: "index_solar_systems_on_battery_id"
    t.index ["power_system_id"], name: "index_solar_systems_on_power_system_id"
    t.index ["project_id"], name: "index_solar_systems_on_project_id"
    t.index ["solar_panel_id"], name: "index_solar_systems_on_solar_panel_id"
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
  add_foreign_key "project_appliances", "appliances"
  add_foreign_key "project_appliances", "projects"
  add_foreign_key "solar_systems", "batteries"
  add_foreign_key "solar_systems", "power_systems"
  add_foreign_key "solar_systems", "projects"
  add_foreign_key "solar_systems", "solar_panels"
  add_foreign_key "sources", "appliances"
end
