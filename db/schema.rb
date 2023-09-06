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

ActiveRecord::Schema[7.0].define(version: 2023_08_12_020753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "account_number"
    t.decimal "balance", precision: 10, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated"
    t.string "token"
    t.string "reset_token"
    t.string "otp_required"
    t.string "otp_secret_key"
    t.boolean "otp_enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "symbol"
    t.string "description"
    t.decimal "current_price", precision: 10, scale: 2
    t.decimal "percent_change", precision: 10, scale: 2
    t.decimal "average_purchase_price", precision: 10, scale: 2
    t.integer "total_quantity"
    t.decimal "total_value", precision: 10, scale: 2
    t.decimal "total_gl", precision: 10, scale: 2
    t.decimal "total_cash_value", precision: 10, scale: 2
    t.bigint "account_id", null: false
    t.bigint "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_portfolios_on_account_id"
    t.index ["stock_id"], name: "index_portfolios_on_stock_id"
  end

  create_table "stock_prices", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "percent_change"
    t.integer "volume"
    t.string "currency"
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_prices_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.string "symbol"
    t.integer "account_number"
    t.decimal "total_cash_value", precision: 10, scale: 2
    t.bigint "account_id", null: false
    t.bigint "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["stock_id"], name: "index_transactions_on_stock_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated", default: false
    t.string "token"
    t.string "reset_token"
    t.string "activation_token"
    t.string "otp_secret_key"
    t.boolean "otp_required", default: true
    t.boolean "otp_enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "portfolios", "accounts"
  add_foreign_key "portfolios", "stocks"
  add_foreign_key "stock_prices", "stocks"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "stocks"
end
