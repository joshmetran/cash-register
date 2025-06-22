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

ActiveRecord::Schema[8.0].define(version: 2025_06_21_185215) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.decimal "price", precision: 16, scale: 2, default: "0.0"
    t.integer "qty"
    t.decimal "total_price", precision: 16, scale: 2, default: "0.0"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "actual_qty"
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "invoice_no"
    t.decimal "total_price", precision: 16, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.decimal "price", precision: 16, scale: 2, default: "0.0"
    t.boolean "is_buy_one_take_one"
    t.boolean "can_bulk_purchase"
    t.integer "min_bulk_purchase"
    t.decimal "bulk_purchase_price", precision: 16, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img_url"
  end

  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
end
