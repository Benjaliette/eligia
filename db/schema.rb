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

ActiveRecord::Schema[7.0].define(version: 2022_12_20_083044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_documents", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_documents_on_account_id"
    t.index ["document_id"], name: "index_account_documents_on_document_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subcategory_id"
    t.string "logo_url"
    t.string "aasm_state"
    t.boolean "need_modal", default: false
    t.text "modal_content"
    t.index ["subcategory_id"], name: "index_accounts_on_subcategory_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "complement"
    t.string "zip"
    t.string "city"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_addresses_on_account_id"
    t.index ["order_id"], name: "index_addresses_on_order_id"
  end

  create_table "blogposts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "user_id", null: false
    t.boolean "pinned", default: false
    t.index ["slug"], name: "index_blogposts_on_slug", unique: true
    t.index ["user_id"], name: "index_blogposts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cgses", force: :cascade do |t|
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.bigint "order_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.string "envoi_id"
    t.index ["order_account_id"], name: "index_deliveries_on_order_account_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "format"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_type"
  end

  create_table "merci_facteurs", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expire_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_account_id"
    t.boolean "read", default: false
    t.index ["order_account_id"], name: "index_notifications_on_order_account_id"
    t.index ["order_id"], name: "index_notifications_on_order_id"
  end

  create_table "order_accounts", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.index ["account_id"], name: "index_order_accounts_on_account_id"
    t.index ["order_id"], name: "index_order_accounts_on_order_id"
  end

  create_table "order_documents", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_input"
    t.index ["document_id"], name: "index_order_documents_on_document_id"
    t.index ["order_id"], name: "index_order_documents_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "deceased_first_name"
    t.string "deceased_last_name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pack_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.string "slug"
    t.string "aasm_state"
    t.boolean "paid", default: false
    t.string "user_email"
    t.index ["pack_id"], name: "index_orders_on_pack_id"
    t.index ["slug"], name: "index_orders_on_slug", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "packs", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "level", null: false
    t.text "description"
    t.string "quantity_text"
  end

  create_table "rgpds", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
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
    t.string "address"
    t.boolean "admin", default: false
    t.string "slug"
    t.string "phone_number"
    t.bigint "rgpd_id"
    t.boolean "accepted_rgpd", default: false
    t.date "birthdate"
    t.bigint "cgs_id"
    t.boolean "accepted_cgs", default: false
    t.index ["cgs_id"], name: "index_users_on_cgs_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rgpd_id"], name: "index_users_on_rgpd_id"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "account_documents", "accounts"
  add_foreign_key "account_documents", "documents"
  add_foreign_key "accounts", "subcategories"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "accounts"
  add_foreign_key "addresses", "orders"
  add_foreign_key "blogposts", "users"
  add_foreign_key "deliveries", "order_accounts"
  add_foreign_key "notifications", "order_accounts"
  add_foreign_key "notifications", "orders"
  add_foreign_key "order_accounts", "accounts"
  add_foreign_key "order_accounts", "orders"
  add_foreign_key "order_documents", "documents"
  add_foreign_key "order_documents", "orders"
  add_foreign_key "orders", "packs"
  add_foreign_key "orders", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "users", "cgses"
  add_foreign_key "users", "rgpds"
end
