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

ActiveRecord::Schema[7.2].define(version: 2024_11_16_115325) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "alcohol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_drinks_on_restaurant_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_features_on_restaurant_id"
  end

  create_table "item_features", force: :cascade do |t|
    t.string "featurable_type"
    t.integer "featurable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feature_id", null: false
    t.index ["featurable_type", "featurable_id"], name: "index_item_features_on_featurable"
    t.index ["feature_id"], name: "index_item_features_on_feature_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "menu_itemable_type", null: false
    t.integer "menu_itemable_id", null: false
    t.integer "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
    t.index ["menu_itemable_type", "menu_itemable_id"], name: "index_menu_items_on_menu_itemable"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "operating_hours", force: :cascade do |t|
    t.string "day"
    t.time "open_time"
    t.time "close_time"
    t.boolean "closed"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_operating_hours_on_restaurant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "portion_id", null: false
    t.integer "order_id", null: false
    t.integer "quantity"
    t.integer "price"
    t.integer "cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["portion_id"], name: "index_order_items_on_portion_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "client_name"
    t.string "cpf"
    t.string "phone"
    t.string "email"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alphanumeric_code"
    t.integer "status"
    t.float "total_price"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "portions", force: :cascade do |t|
    t.string "description"
    t.integer "price_whole"
    t.integer "price_cents"
    t.string "portionable_type", null: false
    t.integer "portionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portionable_type", "portionable_id"], name: "index_portions_on_portionable"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "trade_name"
    t.string "legal_name"
    t.string "cnpj"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alphanumeric_code"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id"
    t.integer "position", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "drinks", "restaurants"
  add_foreign_key "features", "restaurants"
  add_foreign_key "item_features", "features"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "operating_hours", "restaurants"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "portions"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "users", "restaurants"
end
