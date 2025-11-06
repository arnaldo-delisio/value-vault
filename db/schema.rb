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

ActiveRecord::Schema[7.2].define(version: 2025_11_04_174243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stock_id", null: false
    t.bigint "investor_id", null: false
    t.text "question", null: false
    t.text "response"
    t.jsonb "framework_data", default: {}
    t.integer "status", default: 0, null: false
    t.text "error_message"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_analyses_on_completed_at"
    t.index ["investor_id"], name: "index_analyses_on_investor_id"
    t.index ["status"], name: "index_analyses_on_status"
    t.index ["stock_id"], name: "index_analyses_on_stock_id"
    t.index ["user_id", "created_at"], name: "index_analyses_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_analyses_on_user_id"
  end

  create_table "investors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "persona", null: false
    t.text "system_prompt", null: false
    t.jsonb "framework_config", default: {}
    t.string "avatar_url"
    t.boolean "active", default: true, null: false
    t.integer "analyses_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_investors_on_active"
    t.index ["persona"], name: "index_investors_on_persona"
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.jsonb "stock_tickers", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_portfolios_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker", null: false
    t.string "name"
    t.jsonb "cached_data", default: {}
    t.datetime "data_fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticker"], name: "index_stocks_on_ticker", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "tier", default: 0, null: false
    t.integer "analyses_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "analyses", "investors"
  add_foreign_key "analyses", "stocks"
  add_foreign_key "analyses", "users"
  add_foreign_key "portfolios", "users"
end
