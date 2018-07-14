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

ActiveRecord::Schema.define(version: 20180714101753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "agreement_kinds", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_agreement_kinds_on_name"
  end

  create_table "agreements", force: :cascade do |t|
    t.date "beginning"
    t.string "prop"
    t.integer "duration"
    t.boolean "prolongation"
    t.bigint "organization_id"
    t.bigint "contractor_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agreement_kind_id"
    t.index ["agreement_kind_id"], name: "index_agreements_on_agreement_kind_id"
    t.index ["beginning"], name: "index_agreements_on_beginning"
    t.index ["contractor_id"], name: "index_agreements_on_contractor_id"
    t.index ["organization_id"], name: "index_agreements_on_organization_id"
    t.index ["prop"], name: "index_agreements_on_prop"
  end

  create_table "articles", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_articles_on_name"
    t.index ["organization_id"], name: "index_articles_on_organization_id"
    t.index ["user_id"], name: "index_articles_on_user_id"
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

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
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

  create_table "host_services", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.bigint "host_id"
    t.integer "port"
    t.string "protocol"
    t.integer "legality"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vulnerable"
    t.text "vuln_description"
    t.index ["host_id"], name: "index_host_services_on_host_id"
    t.index ["organization_id"], name: "index_host_services_on_organization_id"
    t.index ["port"], name: "index_host_services_on_port"
  end

  create_table "hosts", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.cidr "ip"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip"], name: "index_hosts_on_ip"
    t.index ["organization_id"], name: "index_hosts_on_organization_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.integer "user_id"
    t.datetime "discovered_at"
    t.boolean "discovered_time", default: false
    t.datetime "started_at"
    t.boolean "started_time", default: false
    t.datetime "finished_at"
    t.boolean "finished_time", default: false
    t.datetime "closed_at"
    t.text "event_description"
    t.text "investigation_description"
    t.text "action_description"
    t.integer "severity"
    t.integer "damage"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_incidents_on_organization_id"
    t.index ["user_id"], name: "index_incidents_on_user_id"
  end

  create_table "link_kinds", force: :cascade do |t|
    t.string "name"
    t.string "code_name"
    t.integer "rank"
    t.string "first_record_type"
    t.string "second_record_type"
    t.boolean "equal"
    t.string "color"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "first_record_type"
    t.bigint "first_record_id"
    t.string "second_record_type"
    t.bigint "second_record_id"
    t.bigint "link_kind_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_record_type", "first_record_id"], name: "index_links_on_first_record_type_and_first_record_id"
    t.index ["link_kind_id"], name: "index_links_on_link_kind_id"
    t.index ["second_record_type", "second_record_id"], name: "index_links_on_second_record_type_and_second_record_id"
  end

  create_table "organization_kinds", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organization_kinds_on_name"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.string "full_name"
    t.bigint "organization_kind_id"
    t.index ["full_name"], name: "index_organizations_on_full_name"
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["organization_kind_id"], name: "index_organizations_on_organization_kind_id"
    t.index ["parent_id"], name: "index_organizations_on_parent_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "record_templates", force: :cascade do |t|
    t.string "name"
    t.string "record_content"
    t.string "record_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "scan_jobs", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.string "scan_engine"
    t.bigint "scan_option_id"
    t.string "hosts"
    t.string "ports"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_scan_jobs_on_organization_id"
    t.index ["scan_option_id"], name: "index_scan_jobs_on_scan_option_id"
  end

  create_table "scan_options", force: :cascade do |t|
    t.string "name"
    t.jsonb "options"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scan_results", force: :cascade do |t|
    t.bigint "scan_job_id"
    t.datetime "job_start"
    t.datetime "start"
    t.datetime "finished"
    t.string "scanned_ports"
    t.cidr "ip"
    t.integer "port"
    t.string "protocol"
    t.integer "state"
    t.string "service"
    t.integer "legality"
    t.string "product"
    t.string "product_version"
    t.string "product_extrainfo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "vulns"
    t.index ["port"], name: "index_scan_results_on_port"
    t.index ["product"], name: "index_scan_results_on_product"
    t.index ["scan_job_id"], name: "index_scan_results_on_scan_job_id"
    t.index ["service"], name: "index_scan_results_on_service"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "job_type"
    t.bigint "job_id"
    t.integer "minutes", default: [], array: true
    t.integer "hours", default: [], array: true
    t.integer "month_days", default: [], array: true
    t.integer "months", default: [], array: true
    t.integer "week_days", default: [], array: true
    t.text "crontab_line"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_type", "job_id"], name: "index_schedules_on_job_type_and_job_id"
  end

  create_table "tag_kinds", force: :cascade do |t|
    t.string "name"
    t.string "code_name"
    t.string "record_type"
    t.string "color"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_name"], name: "index_tag_kinds_on_code_name"
    t.index ["name"], name: "index_tag_kinds_on_name"
  end

  create_table "tag_members", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_tag_members_on_record_type_and_record_id"
    t.index ["tag_id"], name: "index_tag_members_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "tag_kind_id"
    t.integer "rank"
    t.string "color"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["tag_kind_id"], name: "index_tags_on_tag_kind_id"
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
    t.integer "rank"
    t.string "department_name"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email"
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

  add_foreign_key "agreements", "agreement_kinds"
  add_foreign_key "agreements", "organizations"
  add_foreign_key "agreements", "organizations", column: "contractor_id"
  add_foreign_key "articles", "organizations"
  add_foreign_key "articles", "users"
  add_foreign_key "attachments", "organizations"
  add_foreign_key "departments", "departments", column: "parent_id"
  add_foreign_key "departments", "organizations"
  add_foreign_key "host_services", "hosts"
  add_foreign_key "host_services", "organizations"
  add_foreign_key "hosts", "organizations"
  add_foreign_key "incidents", "organizations"
  add_foreign_key "incidents", "users"
  add_foreign_key "links", "link_kinds"
  add_foreign_key "organizations", "organization_kinds"
  add_foreign_key "organizations", "organizations", column: "parent_id"
  add_foreign_key "rights", "organizations"
  add_foreign_key "rights", "roles"
  add_foreign_key "role_members", "roles"
  add_foreign_key "role_members", "users"
  add_foreign_key "scan_jobs", "organizations"
  add_foreign_key "scan_jobs", "scan_options"
  add_foreign_key "scan_results", "scan_jobs"
  add_foreign_key "tag_members", "tags"
  add_foreign_key "tags", "tag_kinds"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organizations"
end
