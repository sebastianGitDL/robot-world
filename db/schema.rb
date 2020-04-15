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

ActiveRecord::Schema.define(version: 2020_04_10_144002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_models", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.decimal "price_cost", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_car_models_on_name"
    t.index ["year"], name: "index_car_models_on_year"
  end

  create_table "car_parts", force: :cascade do |t|
    t.string "part_type"
    t.boolean "defective", default: false
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_car_parts_on_car_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "state", default: "basic_structure"
    t.bigint "car_model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_model_id"], name: "index_cars_on_car_model_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date "order_date"
    t.string "status", default: "not_processed"
    t.bigint "car_model_id"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_model_id"], name: "index_orders_on_car_model_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.bigint "stock_location_id"
    t.bigint "car_model_id"
    t.integer "stock", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_model_id"], name: "index_stock_items_on_car_model_id"
    t.index ["stock_location_id"], name: "index_stock_items_on_stock_location_id"
  end

  create_table "stock_locations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
