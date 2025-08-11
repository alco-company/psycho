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

ActiveRecord::Schema[8.0].define(version: 2025_08_11_100000) do
  create_table "domains", force: :cascade do |t|
    t.string "host", null: false
    t.integer "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host"], name: "index_domains_on_host", unique: true
    t.index ["tenant_id"], name: "index_domains_on_tenant_id"
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
    t.index ["slug"], name: "index_tenants_on_slug", unique: true
  end

  add_foreign_key "domains", "tenants"
end
