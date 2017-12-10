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

ActiveRecord::Schema.define(version: 20171203100515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agreements", force: :cascade do |t|
    t.date "beginning"
    t.text "prop"
    t.integer "duration"
    t.boolean "prolongation"
    t.bigint "organization_id"
    t.bigint "contractor_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beginning"], name: "index_agreements_on_beginning"
    t.index ["contractor_id"], name: "index_agreements_on_contractor_id"
    t.index ["organization_id"], name: "index_agreements_on_organization_id"
    t.index ["prop"], name: "index_agreements_on_prop"
  end

  create_table "attachment_links", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.bigint "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_attachment_links_on_attachment_id"
    t.index ["record_type", "record_id"], name: "index_attachment_links_on_record_type_and_record_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "name"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_attachments_on_name"
    t.index ["organization_id"], name: "index_attachments_on_organization_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.bigint "parent_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.index ["name"], name: "index_departments_on_name"
    t.index ["organization_id"], name: "index_departments_on_organization_id"
    t.index ["parent_id"], name: "index_departments_on_parent_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.integer "kind"
    t.index ["kind"], name: "index_organizations_on_kind"
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["parent_id"], name: "index_organizations_on_parent_id"
  end

  create_table "rights", force: :cascade do |t|
    t.bigint "role_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.integer "level"
    t.boolean "inherit", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["inherit"], name: "index_rights_on_inherit"
    t.index ["level"], name: "index_rights_on_level"
    t.index ["organization_id"], name: "index_rights_on_organization_id"
    t.index ["role_id"], name: "index_rights_on_role_id"
    t.index ["subject_type", "subject_id"], name: "index_rights_on_subject_type_and_subject_id"
  end

  create_table "role_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_members_on_role_id"
    t.index ["user_id"], name: "index_role_members_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "organization_id"
    t.string "job"
    t.string "phone"
    t.string "mobile_phone"
    t.text "description"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "single_access_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.boolean "active", default: false
    t.boolean "approved", default: false
    t.boolean "confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "department_id"
    t.integer "job_rank"
    t.integer "rank"
    t.string "department_name"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["job_rank"], name: "index_users_on_job_rank"
    t.index ["name"], name: "index_users_on_name"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["perishable_token"], name: "index_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
    t.index ["single_access_token"], name: "index_users_on_single_access_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "agreements", "organizations"
  add_foreign_key "agreements", "organizations", column: "contractor_id"
  add_foreign_key "attachments", "organizations"
  add_foreign_key "departments", "departments", column: "parent_id"
  add_foreign_key "departments", "organizations"
  add_foreign_key "organizations", "organizations", column: "parent_id"
  add_foreign_key "rights", "organizations"
  add_foreign_key "rights", "roles"
  add_foreign_key "role_members", "roles"
  add_foreign_key "role_members", "users"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organizations"
end
