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

ActiveRecord::Schema[8.0].define(version: 2025_08_11_143003) do
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

  create_table "blogs", force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "comments_setting", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "title"], name: "index_blogs_on_tenant_id_and_title", unique: true
    t.index ["tenant_id"], name: "index_blogs_on_tenant_id"
  end

  create_table "domains", force: :cascade do |t|
    t.string "host", null: false
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "theme_id"
    t.index ["host"], name: "index_domains_on_host", unique: true
    t.index ["tenant_id"], name: "index_domains_on_tenant_id"
    t.index ["theme_id"], name: "index_domains_on_theme_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "blog_id", null: false
    t.string "title"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_posts_on_blog_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "plan"
    t.string "plan_changed_at"
    t.string "plan_expires_at"
    t.string "tax_number"
    t.string "email"
    t.string "locale"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "homepage_title"
    t.text "homepage_body"
    t.integer "default_theme_id"
    t.index ["default_theme_id"], name: "index_tenants_on_default_theme_id"
    t.index ["slug"], name: "index_tenants_on_slug", unique: true
  end

  create_table "themes", force: :cascade do |t|
    t.string "name", null: false
    t.text "html_layout", default: "", null: false
    t.text "css"
    t.text "js"
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_themes_on_tenant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blogs", "tenants"
  add_foreign_key "domains", "tenants"
  add_foreign_key "domains", "themes"
  add_foreign_key "posts", "blogs"
  add_foreign_key "tenants", "themes", column: "default_theme_id"
  add_foreign_key "themes", "tenants"
end
