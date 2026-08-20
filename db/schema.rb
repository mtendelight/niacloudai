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

ActiveRecord::Schema[8.1].define(version: 2026_08_07_164251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounting_accounts", force: :cascade do |t|
    t.string "account_type"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_accounting_accounts_on_company_id"
  end

  create_table "accounting_journal_entries", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "date"
    t.string "description"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_accounting_journal_entries_on_company_id"
  end

  create_table "accounting_journal_lines", force: :cascade do |t|
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.decimal "credit"
    t.decimal "debit"
    t.bigint "journal_entry_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_accounting_journal_lines_on_account_id"
    t.index ["journal_entry_id"], name: "index_accounting_journal_lines_on_journal_entry_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "account_type"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_accounts_on_company_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "disclaimer"
    t.string "end_date"
    t.string "start"
    t.datetime "updated_at", null: false
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time", precision: nil
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "app_version"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.float "latitude"
    t.float "longitude"
    t.string "os"
    t.string "os_version"
    t.string "platform"
    t.text "referrer"
    t.string "referring_domain"
    t.string "region"
    t.datetime "started_at", precision: nil
    t.text "user_agent"
    t.bigint "user_id"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "aiconversations", force: :cascade do |t|
    t.bigint "aicustomer_id"
    t.datetime "created_at", null: false
    t.text "summary"
    t.datetime "updated_at", null: false
    t.index ["aicustomer_id"], name: "index_aiconversations_on_aicustomer_id"
  end

  create_table "aicustomers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "aiknowledges", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "category"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "keywords"
    t.string "slug"
    t.string "source_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["active"], name: "index_aiknowledges_on_active"
    t.index ["category"], name: "index_aiknowledges_on_category"
    t.index ["slug"], name: "index_aiknowledges_on_slug", unique: true
  end

  create_table "ailogs", force: :cascade do |t|
    t.bigint "aicustomer_id"
    t.string "channel", default: "whatsapp", null: false
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.text "message"
    t.string "phone"
    t.datetime "received_at"
    t.datetime "updated_at", null: false
    t.index ["aicustomer_id"], name: "index_ailogs_on_aicustomer_id"
    t.index ["channel"], name: "index_ailogs_on_channel"
  end

  create_table "aimessages", force: :cascade do |t|
    t.bigint "aiconversation_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "message_type"
    t.string "phone"
    t.string "role"
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "whatsapp_message_id"
    t.index ["aiconversation_id"], name: "index_aimessages_on_aiconversation_id"
    t.index ["whatsapp_message_id"], name: "index_aimessages_on_whatsapp_message_id", unique: true
  end

  create_table "aipages", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "last_synced_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["active"], name: "index_aipages_on_active"
    t.index ["url"], name: "index_aipages_on_url", unique: true
  end

  create_table "aiproducts", force: :cascade do |t|
    t.string "bale_name", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "pieces_range"
    t.decimal "price", precision: 12, scale: 2
    t.datetime "updated_at", null: false
    t.index ["bale_name"], name: "index_aiproducts_on_bale_name"
  end

  create_table "airbnbs", force: :cascade do |t|
    t.string "caretaker"
    t.string "cleaner"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location_address"
    t.string "name"
    t.decimal "price"
    t.string "town"
    t.datetime "updated_at", null: false
  end

  create_table "aisettings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
    t.text "value"
  end

  create_table "areas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "employee_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_attendances_on_company_id"
    t.index ["employee_id"], name: "index_attendances_on_employee_id"
  end

  create_table "audits", force: :cascade do |t|
    t.string "action"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "auditable_id"
    t.string "auditable_type"
    t.text "audited_changes"
    t.string "comment"
    t.datetime "created_at", precision: nil
    t.string "remote_address"
    t.string "request_uuid"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.integer "version", default: 0
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bales", force: :cascade do |t|
    t.string "bale_name"
    t.text "comments"
    t.datetime "created_at", null: false
    t.boolean "delivered"
    t.boolean "dispatching"
    t.string "full_name"
    t.string "location"
    t.boolean "paid"
    t.string "phone_number"
    t.boolean "transport_paid"
    t.datetime "updated_at", null: false
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount"
    t.string "category"
    t.datetime "created_at", null: false
    t.date "due_date"
    t.boolean "paid"
    t.text "payment_details"
    t.boolean "recurring"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "blocks", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "bnbcurrencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "bnbprices", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "adults_qty", default: 0, null: false
    t.integer "adventure_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "email"
    t.integer "kids_0_3_qty", default: 0, null: false
    t.integer "kids_12_plus_qty", default: 0, null: false
    t.integer "kids_4_11_qty", default: 0, null: false
    t.bigint "momakevent_id"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["momakevent_id"], name: "index_bookings_on_momakevent_id"
  end

  create_table "branches", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "brand_visibilities", force: :cascade do |t|
    t.string "channel"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.integer "reach"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.bigint "block_id"
    t.string "category"
    t.datetime "created_at", null: false
    t.string "logo"
    t.string "name"
    t.decimal "revenue"
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_businesses_on_block_id"
  end

  create_table "campaign_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error_message"
    t.string "message_id"
    t.string "name"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "campaign_manifestos", force: :cascade do |t|
    t.decimal "budget"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "objective"
    t.date "start_date"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "cinvoice_items", force: :cascade do |t|
    t.bigint "cinvoice_id"
    t.datetime "created_at", null: false
    t.string "description"
    t.decimal "quantity"
    t.decimal "total"
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
    t.index ["cinvoice_id"], name: "index_cinvoice_items_on_cinvoice_id"
  end

  create_table "cinvoices", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "contractor_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.string "invoice_number"
    t.date "issue_date"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["contractor_id"], name: "index_cinvoices_on_contractor_id"
    t.index ["invoice_number"], name: "index_cinvoices_on_invoice_number", unique: true
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "data_content_type"
    t.string "data_file_name", null: false
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clients", force: :cascade do |t|
    t.string "alternative_phone"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.decimal "payment_amount"
    t.date "payment_date"
    t.string "payment_duration"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "likes", default: 0
    t.bigint "niabnb_id"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["niabnb_id"], name: "index_comments_on_niabnb_id"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "whatsapp_message_id"
    t.string "whatsapp_status"
  end

  create_table "contractors", force: :cascade do |t|
    t.string "contact_person"
    t.datetime "created_at", null: false
    t.string "kra_pin"
    t.string "location"
    t.string "name"
    t.string "phone"
    t.text "scope"
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipient_id"
    t.bigint "sender_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "core_activity_logs", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.integer "record_id"
    t.string "record_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_core_activity_logs_on_user_id"
  end

  create_table "core_branches", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_branches_on_company_id"
  end

  create_table "core_companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "core_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end"
    t.string "event_type"
    t.datetime "start"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_core_events_on_user_id"
  end

  create_table "core_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message"
    t.boolean "read"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_core_notifications_on_user_id"
  end

  create_table "counsellors", force: :cascade do |t|
    t.integer "age"
    t.boolean "approved", default: false, null: false
    t.string "cert_public_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "id_number"
    t.string "location"
    t.string "other_public_id"
    t.string "phone"
    t.string "resume_public_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_counsellors_on_email", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "cpayments", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "cinvoice_id"
    t.datetime "created_at", null: false
    t.string "method"
    t.text "notes"
    t.date "payment_date"
    t.string "reference"
    t.datetime "updated_at", null: false
    t.index ["cinvoice_id"], name: "index_cpayments_on_cinvoice_id"
  end

  create_table "crm_customers", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_crm_customers_on_company_id"
  end

  create_table "crm_leads", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_crm_leads_on_company_id"
  end

  create_table "cstatements", force: :cascade do |t|
    t.decimal "balance"
    t.bigint "contractor_id"
    t.datetime "created_at", null: false
    t.date "from_date"
    t.date "to_date"
    t.decimal "total_invoiced"
    t.decimal "total_paid"
    t.datetime "updated_at", null: false
    t.index ["contractor_id"], name: "index_cstatements_on_contractor_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "alternative_phone"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.decimal "payment_amount"
    t.date "payment_date"
    t.string "payment_duration"
    t.string "phone"
    t.integer "quantity"
    t.datetime "updated_at", null: false
  end

  create_table "daily_tasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "due_date"
    t.text "notes"
    t.integer "position"
    t.string "status"
    t.date "task_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_daily_tasks_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at"
    t.datetime "failed_at"
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at"
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dispatchmmfs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "id_number"
    t.decimal "interest"
    t.bigint "mmf_id"
    t.string "name"
    t.string "period"
    t.string "phone"
    t.decimal "principal"
    t.string "status"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.index ["mmf_id"], name: "index_dispatchmmfs_on_mmf_id"
  end

  create_table "dsa_sales", force: :cascade do |t|
    t.string "branch"
    t.datetime "created_at", null: false
    t.bigint "dsa_id"
    t.date "sale_date"
    t.integer "sales_done"
    t.datetime "updated_at", null: false
    t.index ["dsa_id"], name: "index_dsa_sales_on_dsa_id"
  end

  create_table "dsas", force: :cascade do |t|
    t.string "assigned_branches"
    t.datetime "created_at", null: false
    t.string "full_name"
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "position"
    t.decimal "salary"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
  end

  create_table "equitypays", force: :cascade do |t|
    t.decimal "bill_amount"
    t.string "bill_currency"
    t.string "bill_reference"
    t.datetime "created_at", null: false
    t.string "payer_account"
    t.string "payer_name"
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_time"
    t.string "location"
    t.datetime "start_time"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.decimal "amount"
    t.string "branch"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.string "exp_id"
    t.text "notes"
    t.bigint "payment_method_id"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_expenditures_on_category_id"
    t.index ["payment_method_id"], name: "index_expenditures_on_payment_method_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "feedback", null: false
    t.string "name", null: false
    t.integer "rate", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ffes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "fleets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "last_service_date"
    t.string "name"
    t.text "notes"
    t.string "plate_number"
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "vehicle_type"
  end

  create_table "fmes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "fme"
    t.string "mobile_number"
    t.datetime "updated_at", null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "updated_at", null: false
  end

  create_table "hr_attendances", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.datetime "created_at", null: false
    t.bigint "employee_id"
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_hr_attendances_on_employee_id"
  end

  create_table "hr_employees", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.decimal "salary"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["company_id"], name: "index_hr_employees_on_company_id"
    t.index ["user_id"], name: "index_hr_employees_on_user_id"
  end

  create_table "ict_issuances", force: :cascade do |t|
    t.string "condition"
    t.datetime "created_at", null: false
    t.date "issued_on"
    t.string "item_name"
    t.string "item_type"
    t.text "notes"
    t.date "returned_on"
    t.string "serial_number"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_ict_issuances_on_user_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "action_name"
    t.string "controller_name"
    t.datetime "created_at", null: false
    t.integer "impressionable_id"
    t.string "impressionable_type"
    t.string "ip_address"
    t.text "message"
    t.text "params"
    t.text "referrer"
    t.string "request_hash"
    t.string "session_hash"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "view_name"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "quantity"
    t.integer "reorder_level"
    t.datetime "updated_at", null: false
  end

  create_table "inventory_products", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_inventory_products_on_company_id"
  end

  create_table "inventory_stock_movements", force: :cascade do |t|
    t.bigint "branch_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "movement_type"
    t.bigint "product_id"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_inventory_stock_movements_on_branch_id"
    t.index ["company_id"], name: "index_inventory_stock_movements_on_company_id"
    t.index ["product_id"], name: "index_inventory_stock_movements_on_product_id"
  end

  create_table "issues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ffe_id"
    t.string "item_name"
    t.string "material_id"
    t.string "phone_number"
    t.string "picker_name"
    t.integer "quantity"
    t.string "uom"
    t.datetime "updated_at", null: false
  end

  create_table "jagencyperformances", force: :cascade do |t|
    t.string "agent"
    t.integer "bales_sold"
    t.datetime "created_at", null: false
    t.date "record_date"
    t.datetime "updated_at", null: false
    t.index ["agent", "record_date"], name: "index_jagencyperformances_on_agent_and_record_date", unique: true
  end

  create_table "janomax_bale_items", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.bigint "jbale_id"
    t.integer "quantity"
    t.decimal "selling_price"
    t.datetime "updated_at", null: false
    t.index ["jbale_id"], name: "index_janomax_bale_items_on_jbale_id"
  end

  create_table "janomax_bale_openings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "jbale_id"
    t.decimal "profit"
    t.decimal "revenue"
    t.datetime "updated_at", null: false
    t.index ["jbale_id"], name: "index_janomax_bale_openings_on_jbale_id"
  end

  create_table "janomax_bales", force: :cascade do |t|
    t.string "code"
    t.bigint "company_id"
    t.decimal "cost_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_janomax_bales_on_company_id"
  end

  create_table "janomax_outbound_calls", force: :cascade do |t|
    t.string "agent"
    t.datetime "called_at"
    t.datetime "created_at", null: false
    t.string "direction"
    t.bigint "janomaxlead_id"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["janomaxlead_id"], name: "index_janomax_outbound_calls_on_janomaxlead_id"
  end

  create_table "janomaxes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "item_description"
    t.string "item_name"
    t.bigint "jcustomer_id"
    t.bigint "jmcustomer_id"
    t.string "pieces"
    t.string "sample"
    t.integer "selling_price"
    t.datetime "updated_at", null: false
    t.index ["jcustomer_id"], name: "index_janomaxes_on_jcustomer_id"
    t.index ["jmcustomer_id"], name: "index_janomaxes_on_jmcustomer_id"
  end

  create_table "janomaxleadcalls", force: :cascade do |t|
    t.string "agent"
    t.datetime "called_at"
    t.datetime "created_at", null: false
    t.string "direction"
    t.bigint "janomaxlead_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["called_at"], name: "index_janomaxleadcalls_on_called_at"
    t.index ["janomaxlead_id"], name: "index_janomaxleadcalls_on_janomaxlead_id"
    t.index ["status"], name: "index_janomaxleadcalls_on_status"
  end

  create_table "janomaxleads", force: :cascade do |t|
    t.integer "calls_count"
    t.text "comments"
    t.datetime "created_at", null: false
    t.boolean "customer_exists"
    t.bigint "jmcustomer_id"
    t.datetime "last_called_at"
    t.datetime "last_handled_at"
    t.string "last_status"
    t.string "lead_status"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["customer_exists"], name: "index_janomaxleads_on_customer_exists"
    t.index ["jmcustomer_id"], name: "index_janomaxleads_on_jmcustomer_id"
    t.index ["lead_status"], name: "index_janomaxleads_on_lead_status"
    t.index ["phone"], name: "index_janomaxleads_on_phone", unique: true
  end

  create_table "jbales", force: :cascade do |t|
    t.string "bale_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "flash_sale_amount"
    t.bigint "jcategory_id"
    t.integer "original_amount"
    t.string "photo"
    t.boolean "published"
    t.datetime "updated_at", null: false
    t.index ["jcategory_id"], name: "index_jbales_on_jcategory_id"
  end

  create_table "jbranches", force: :cascade do |t|
    t.string "address"
    t.string "branch_name"
    t.datetime "created_at", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "jbranchperformances", force: :cascade do |t|
    t.integer "bales_sold", null: false
    t.string "branch", null: false
    t.datetime "created_at", null: false
    t.date "record_date", null: false
    t.datetime "updated_at", null: false
    t.index ["branch", "record_date"], name: "index_jbranchperformances_on_branch_and_record_date", unique: true
  end

  create_table "jbudget_expenses", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.bigint "jbudget_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["jbudget_id"], name: "index_jbudget_expenses_on_jbudget_id"
  end

  create_table "jbudgets", force: :cascade do |t|
    t.decimal "business_income"
    t.datetime "created_at", null: false
    t.decimal "other_income"
    t.string "period"
    t.decimal "salary_income"
    t.datetime "updated_at", null: false
  end

  create_table "jcalendars", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "jcategories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_jcategories_on_name", unique: true
  end

  create_table "jcustomers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "jdeliveries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "delivery_price", precision: 10, scale: 2, default: "0.0"
    t.bigint "jorder_id"
    t.integer "mode", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["jorder_id"], name: "index_jdeliveries_on_jorder_id"
  end

  create_table "jevents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end"
    t.bigint "jcalendar_id"
    t.datetime "start"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["jcalendar_id"], name: "index_jevents_on_jcalendar_id"
  end

  create_table "jfaqs", force: :cascade do |t|
    t.text "answer"
    t.string "category"
    t.datetime "created_at", null: false
    t.string "question"
    t.datetime "updated_at", null: false
  end

  create_table "jfeedbacks", force: :cascade do |t|
    t.string "contact"
    t.datetime "created_at", null: false
    t.text "feedback"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "jfulfillments", force: :cascade do |t|
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "feedback"
    t.string "fulfillment_key"
    t.string "issue_status", default: "pending", null: false
    t.text "items"
    t.bigint "jmcustomer_id"
    t.string "location"
    t.string "name"
    t.string "phone"
    t.string "status"
    t.string "transaction_ref"
    t.datetime "updated_at", null: false
    t.index ["fulfillment_key"], name: "index_jfulfillments_on_fulfillment_key", unique: true
    t.index ["jmcustomer_id", "transaction_ref"], name: "idx_fulfillments_customer_transaction", unique: true
    t.index ["jmcustomer_id"], name: "index_jfulfillments_on_jmcustomer_id"
  end

  create_table "jmap_locations", force: :cascade do |t|
    t.boolean "active"
    t.string "address"
    t.integer "branch_id"
    t.datetime "created_at", null: false
    t.string "entity_name"
    t.string "entity_type"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "sales_manager_email"
    t.string "sales_manager_name"
    t.string "sales_manager_phone"
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_jmap_locations_on_branch_id"
  end

  create_table "jmcallcomments", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "jmcustomer_id"
    t.datetime "updated_at", null: false
    t.index ["jmcustomer_id"], name: "index_jmcallcomments_on_jmcustomer_id"
  end

  create_table "jmcustomer_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "imported", default: false, null: false
    t.bigint "janomax_id"
    t.bigint "jmcustomer_id"
    t.bigint "jstock_id"
    t.datetime "updated_at", null: false
    t.index ["janomax_id"], name: "index_jmcustomer_items_on_janomax_id"
    t.index ["jmcustomer_id"], name: "index_jmcustomer_items_on_jmcustomer_id"
    t.index ["jstock_id"], name: "index_jmcustomer_items_on_jstock_id"
  end

  create_table "jmcustomers", force: :cascade do |t|
    t.boolean "acquired_from_lead"
    t.boolean "blacklist", default: false, null: false
    t.text "callcomments"
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "feedback"
    t.datetime "first_contacted_at"
    t.boolean "imported"
    t.bigint "jmlead_id"
    t.string "location"
    t.string "name"
    t.string "phone"
    t.integer "points", default: 0
    t.boolean "returning"
    t.datetime "updated_at", null: false
    t.index ["jmlead_id"], name: "index_jmcustomers_on_jmlead_id"
    t.index ["phone"], name: "index_jmcustomers_on_phone"
  end

  create_table "jmleads", force: :cascade do |t|
    t.text "comments"
    t.text "conversation"
    t.datetime "converted_at"
    t.datetime "created_at", null: false
    t.text "general_comments"
    t.text "items_required"
    t.bigint "jmcustomer_id"
    t.bigint "jstaff_id"
    t.datetime "last_customer_message_at"
    t.datetime "last_handled_at"
    t.string "name"
    t.string "phone"
    t.string "sglid"
    t.string "source"
    t.string "status", default: "open"
    t.datetime "updated_at", null: false
    t.index ["jmcustomer_id"], name: "index_jmleads_on_jmcustomer_id"
    t.index ["jstaff_id"], name: "index_jmleads_on_jstaff_id"
    t.index ["phone"], name: "index_jmleads_on_phone"
    t.index ["sglid"], name: "index_jmleads_on_sglid", unique: true
  end

  create_table "jmpayments", force: :cascade do |t|
    t.integer "agent_id"
    t.decimal "amount"
    t.integer "bales_count"
    t.text "comments"
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "jmcustomer_id"
    t.string "mpesa_code"
    t.string "mpesa_number"
    t.string "name"
    t.string "transaction_ref"
    t.datetime "updated_at", null: false
    t.index ["jmcustomer_id"], name: "index_jmpayments_on_jmcustomer_id"
    t.index ["mpesa_number"], name: "index_jmpayments_on_mpesa_number"
    t.index ["transaction_ref"], name: "index_jmpayments_on_transaction_ref", unique: true
  end

  create_table "jmreward_redemptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "jmcustomer_id"
    t.integer "points"
    t.string "redeemed_by"
    t.datetime "updated_at", null: false
    t.index ["jmcustomer_id"], name: "index_jmreward_redemptions_on_jmcustomer_id"
  end

  create_table "jnewsales", force: :cascade do |t|
    t.decimal "amount"
    t.string "bale_name"
    t.string "branch"
    t.datetime "created_at", null: false
    t.text "note"
    t.integer "qty"
    t.decimal "selling_price"
    t.datetime "updated_at", null: false
  end

  create_table "jnewstocks", force: :cascade do |t|
    t.decimal "amount"
    t.string "bale_name"
    t.string "branch"
    t.datetime "created_at", null: false
    t.text "note"
    t.integer "qty"
    t.decimal "selling_price"
    t.datetime "updated_at", null: false
  end

  create_table "job_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "openjob_id"
    t.string "status"
    t.bigint "talent_id"
    t.datetime "updated_at", null: false
    t.index ["openjob_id"], name: "index_job_applications_on_openjob_id"
    t.index ["talent_id"], name: "index_job_applications_on_talent_id"
  end

  create_table "jorder_items", force: :cascade do |t|
    t.jsonb "bales_details"
    t.datetime "created_at", null: false
    t.integer "flash_unit_price"
    t.bigint "jbale_id"
    t.bigint "jorder_id"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["jbale_id"], name: "index_jorder_items_on_jbale_id"
    t.index ["jorder_id"], name: "index_jorder_items_on_jorder_id"
  end

  create_table "jorders", force: :cascade do |t|
    t.string "cellphone"
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.boolean "delivery_done"
    t.integer "fulfillment"
    t.bigint "jbranch_id"
    t.string "location"
    t.string "mpesa_code"
    t.string "name"
    t.boolean "paid"
    t.string "session_id"
    t.integer "total_amount"
    t.datetime "updated_at", null: false
    t.index ["jbranch_id"], name: "index_jorders_on_jbranch_id"
    t.index ["session_id"], name: "index_jorders_on_session_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "description"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_journal_entries_on_company_id"
  end

  create_table "journal_lines", force: :cascade do |t|
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.decimal "credit"
    t.decimal "debit"
    t.bigint "journal_entry_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_journal_lines_on_account_id"
    t.index ["journal_entry_id"], name: "index_journal_lines_on_journal_entry_id"
  end

  create_table "joutputs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "month"
    t.integer "qty"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "jpartialstocks", force: :cascade do |t|
    t.decimal "amount"
    t.string "bale_name"
    t.string "branch"
    t.datetime "created_at", null: false
    t.bigint "jstock_id"
    t.text "note"
    t.decimal "qty"
    t.decimal "selling_price"
    t.datetime "updated_at", null: false
    t.index ["jstock_id"], name: "index_jpartialstocks_on_jstock_id"
  end

  create_table "jpermits", force: :cascade do |t|
    t.string "branch"
    t.datetime "created_at", null: false
    t.string "financial_year"
    t.string "permit_pdf"
    t.string "permit_public_id"
    t.datetime "updated_at", null: false
  end

  create_table "jreferrals", force: :cascade do |t|
    t.text "bales_interested_in"
    t.boolean "converted"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.string "location"
    t.string "mpesa_number"
    t.string "phone_number"
    t.datetime "updated_at", null: false
  end

  create_table "jrevenues", force: :cascade do |t|
    t.decimal "cash", default: "0.0"
    t.text "cash_comment"
    t.decimal "cbk_treasury_bonds", precision: 15, scale: 2, default: "0.0"
    t.text "cbk_treasury_bonds_comment"
    t.decimal "chama", default: "0.0"
    t.text "chama_comment"
    t.text "comments"
    t.datetime "created_at", null: false
    t.decimal "customer", default: "0.0"
    t.text "customer_comment"
    t.decimal "household", precision: 15, scale: 2, default: "0.0"
    t.text "household_comment"
    t.decimal "insurance_savings", precision: 15, scale: 2, default: "0.0"
    t.text "insurance_savings_comment"
    t.decimal "kingdom_bank", default: "0.0"
    t.text "kingdom_bank_comment"
    t.decimal "money_market", precision: 15, scale: 2, default: "0.0"
    t.text "money_market_comment"
    t.decimal "mpesa", default: "0.0"
    t.text "mpesa_comment"
    t.decimal "nairobi", default: "0.0"
    t.text "nairobi_comment"
    t.decimal "nbk_bank", default: "0.0"
    t.text "nbk_bank_comment"
    t.decimal "other_savings", precision: 15, scale: 2, default: "0.0"
    t.text "other_savings_comment"
    t.decimal "others", default: "0.0"
    t.text "others_comment"
    t.decimal "pochi", default: "0.0"
    t.text "pochi_comment"
    t.decimal "stock", default: "0.0"
    t.text "stock_comment"
    t.datetime "updated_at", null: false
  end

  create_table "jsamples", force: :cascade do |t|
    t.string "bale_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "pieces_range"
    t.string "price_range"
    t.string "sample"
    t.datetime "updated_at", null: false
    t.string "video"
    t.string "video_public_id"
  end

  create_table "jsession_slots", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.integer "day_of_week"
    t.time "end_time"
    t.time "start_time"
    t.datetime "updated_at", null: false
  end

  create_table "jsessions", force: :cascade do |t|
    t.integer "amount"
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.time "end_time"
    t.string "full_name"
    t.string "mpesa_code"
    t.boolean "paid", default: false
    t.string "payment_reference"
    t.string "phone"
    t.boolean "session_confirmed", default: false
    t.date "session_date"
    t.time "start_time"
    t.integer "status"
    t.text "story"
    t.integer "total_amount", default: 2000
    t.datetime "updated_at", null: false
    t.string "username"
  end

  create_table "jstaffs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "phone"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  create_table "jstocks", force: :cascade do |t|
    t.decimal "amount", default: "0.0", null: false
    t.string "bale_name"
    t.string "branch"
    t.string "comment"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "pieces_range"
    t.decimal "qty", precision: 10, scale: 2
    t.decimal "selling_price"
    t.datetime "updated_at", null: false
    t.index ["bale_name", "branch"], name: "index_jstocks_on_bale_name_and_branch", unique: true
    t.index ["bale_name"], name: "index_jstocks_on_bale_name"
    t.index ["branch"], name: "index_jstocks_on_branch"
  end

  create_table "jtargets", force: :cascade do |t|
    t.decimal "achieved", precision: 12, scale: 2
    t.decimal "crazy_targets", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.string "months"
    t.decimal "target", precision: 12, scale: 2
    t.datetime "updated_at", null: false
  end

  create_table "jtasks", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "done"
    t.datetime "due_time"
    t.text "notes"
    t.string "priority"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "jtickets", force: :cascade do |t|
    t.string "ONUSN"
    t.string "assignee"
    t.text "comments"
    t.string "contacts"
    t.string "contractor"
    t.datetime "created_at", null: false
    t.string "customer_details"
    t.datetime "date_assigned"
    t.string "location"
    t.string "notific"
    t.string "pmorder"
    t.string "status"
    t.string "tt"
    t.datetime "updated_at", null: false
  end

  create_table "kitchen_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "knowledge_feedbacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "feedback_type"
    t.integer "occurrences", default: 1
    t.string "priority", default: "medium"
    t.text "question"
    t.text "recommendation"
    t.string "source", default: "AI"
    t.string "status", default: "pending"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["title", "feedback_type"], name: "index_knowledge_feedbacks_on_title_and_feedback_type", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "locs", force: :cascade do |t|
    t.integer "atb"
    t.string "clears"
    t.string "comment"
    t.datetime "created_at", null: false
    t.integer "drop_cable"
    t.string "fme_id"
    t.string "inc"
    t.string "lat"
    t.string "long"
    t.text "notes"
    t.string "ont"
    t.date "planned_date"
    t.integer "poles"
    t.string "reason_id"
    t.string "region_id"
    t.datetime "remedy_date", precision: nil
    t.string "residential_type"
    t.string "service"
    t.string "status_id"
    t.text "summary"
    t.integer "trunking"
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.string "username"
  end

  create_table "m_accounts", force: :cascade do |t|
    t.string "account_type"
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.boolean "low_balance_alert_sent"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "m_adventure_hotels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "m_adventure_id"
    t.bigint "m_hotel_id"
    t.datetime "updated_at", null: false
    t.index ["m_adventure_id"], name: "index_m_adventure_hotels_on_m_adventure_id"
    t.index ["m_hotel_id"], name: "index_m_adventure_hotels_on_m_hotel_id"
  end

  create_table "m_adventures", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.string "location"
    t.string "name"
    t.string "photo_url"
    t.string "plan"
    t.decimal "rate"
    t.date "start_date"
    t.datetime "updated_at", null: false
  end

  create_table "m_approvals", force: :cascade do |t|
    t.bigint "approvable_id"
    t.string "approvable_type"
    t.datetime "approved_at"
    t.string "approved_by"
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["approvable_type", "approvable_id"], name: "index_m_approvals_on_approvable"
  end

  create_table "m_bookings", force: :cascade do |t|
    t.decimal "amount"
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "id_number"
    t.bigint "m_adventure_id"
    t.string "name"
    t.string "payment_status", default: "pending"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["m_adventure_id"], name: "index_m_bookings_on_m_adventure_id"
  end

  create_table "m_customers", force: :cascade do |t|
    t.bigint "airbnb_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["airbnb_id"], name: "index_m_customers_on_airbnb_id"
  end

  create_table "m_employees", force: :cascade do |t|
    t.integer "annual_leave_balance"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "position"
    t.decimal "salary"
    t.integer "sick_leave_balance"
    t.string "staff_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["staff_id"], name: "index_m_employees_on_staff_id", unique: true
  end

  create_table "m_hotels", force: :cascade do |t|
    t.string "address"
    t.string "contact"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.string "location"
    t.string "name"
    t.string "phone"
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.string "website"
  end

  create_table "m_invoice_items", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "m_invoice_id"
    t.integer "no"
    t.integer "quantity"
    t.decimal "unit_price"
    t.string "uom"
    t.datetime "updated_at", null: false
    t.index ["m_invoice_id"], name: "index_m_invoice_items_on_m_invoice_id"
  end

  create_table "m_invoices", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "file"
    t.string "invoice_number"
    t.bigint "m_po_id"
    t.bigint "m_subcontractor_id"
    t.string "permit_public_id"
    t.string "status"
    t.decimal "tax_amount", precision: 12, scale: 2, default: "0.0"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.index ["m_po_id"], name: "index_m_invoices_on_m_po_id"
    t.index ["m_subcontractor_id"], name: "index_m_invoices_on_m_subcontractor_id"
  end

  create_table "m_payments", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.string "file"
    t.bigint "m_invoice_id"
    t.bigint "m_subcontractor_id"
    t.string "method"
    t.date "payment_date"
    t.string "permit_public_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["m_invoice_id"], name: "index_m_payments_on_m_invoice_id"
    t.index ["m_subcontractor_id"], name: "index_m_payments_on_m_subcontractor_id"
  end

  create_table "m_payrolls", force: :cascade do |t|
    t.decimal "allowances"
    t.decimal "basic_salary"
    t.datetime "created_at", null: false
    t.decimal "deductions"
    t.bigint "m_employee_id"
    t.decimal "net_salary"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["m_employee_id"], name: "index_m_payrolls_on_m_employee_id"
  end

  create_table "m_po_items", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.string "description"
    t.bigint "m_po_id"
    t.integer "no"
    t.integer "quantity"
    t.decimal "unit_price"
    t.string "uom"
    t.datetime "updated_at", null: false
    t.index ["m_po_id"], name: "index_m_po_items_on_m_po_id"
  end

  create_table "m_pos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "m_subcontractor_id"
    t.string "po_number"
    t.string "status"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.index ["m_subcontractor_id"], name: "index_m_pos_on_m_subcontractor_id"
  end

  create_table "m_statements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.bigint "m_subcontractor_id"
    t.date "start_date"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.index ["m_subcontractor_id"], name: "index_m_statements_on_m_subcontractor_id"
  end

  create_table "m_subcontractors", force: :cascade do |t|
    t.string "contact"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "m_time_offs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.string "leave_type"
    t.bigint "m_employee_id"
    t.text "reason"
    t.integer "remaining_days"
    t.date "start_date"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "used_days"
    t.index ["m_employee_id"], name: "index_m_time_offs_on_m_employee_id"
  end

  create_table "m_transactions", force: :cascade do |t|
    t.decimal "amount"
    t.string "cost_centre"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "m_account_id"
    t.string "transaction_type"
    t.datetime "updated_at", null: false
    t.index ["m_account_id"], name: "index_m_transactions_on_m_account_id"
  end

  create_table "match_requests", force: :cascade do |t|
    t.integer "amount_paid"
    t.string "body_type"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "education_level"
    t.string "email"
    t.datetime "expires_at"
    t.string "height_range"
    t.text "interests"
    t.string "lifestyle"
    t.string "location"
    t.string "marital_status"
    t.integer "max_age"
    t.string "mid"
    t.integer "min_age"
    t.string "mpesa_reference"
    t.string "occupation"
    t.boolean "paid"
    t.datetime "paid_at"
    t.string "phone"
    t.string "photo"
    t.string "preferred_gender"
    t.string "religion"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "username"
    t.index ["user_id"], name: "index_match_requests_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "issue"
    t.integer "issue_id"
    t.string "item_name"
    t.integer "new_stock_id"
    t.integer "office_stock"
    t.integer "stock"
    t.string "uom"
    t.datetime "updated_at", null: false
    t.integer "utilize"
    t.integer "utilize_id"
  end

  create_table "mattendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.bigint "mentorship_id"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["mentorship_id"], name: "index_mattendances_on_mentorship_id"
  end

  create_table "mbookings", force: :cascade do |t|
    t.integer "age"
    t.integer "assigned_to_id"
    t.string "booking_number"
    t.string "booking_source"
    t.text "brief_description"
    t.string "closure_reason"
    t.bigint "counsellor_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.string "email"
    t.boolean "follow_up_required"
    t.string "full_name"
    t.string "gender"
    t.datetime "last_session_date"
    t.datetime "next_session_date"
    t.string "payment_status"
    t.string "phone_number"
    t.text "reason_for_visit"
    t.string "service_type"
    t.integer "sessions_count"
    t.string "status"
    t.decimal "total_billed"
    t.decimal "total_paid"
    t.datetime "updated_at", null: false
    t.string "urgency_level"
    t.index ["assigned_to_id"], name: "index_mbookings_on_assigned_to_id"
    t.index ["booking_number"], name: "index_mbookings_on_booking_number", unique: true
    t.index ["counsellor_id"], name: "index_mbookings_on_counsellor_id"
    t.index ["phone_number"], name: "index_mbookings_on_phone_number"
    t.index ["status"], name: "index_mbookings_on_status"
  end

  create_table "mcalendars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "mcomments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "project_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["project_id"], name: "index_mcomments_on_project_id"
    t.index ["user_id"], name: "index_mcomments_on_user_id"
  end

  create_table "mcontacts", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.text "notes"
    t.string "phone"
    t.string "position"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_mcontacts_on_user_id"
  end

  create_table "mentorships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.string "location"
    t.string "name"
    t.integer "planned_visitors"
    t.time "time"
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "barcode"
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "new_stock"
    t.integer "order_id"
    t.decimal "price"
    t.integer "stock"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "attachment"
    t.string "attachment_filename"
    t.text "content"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.integer "reply_to_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "mevents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_time"
    t.bigint "mcalendar_id"
    t.datetime "start_time"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["mcalendar_id"], name: "index_mevents_on_mcalendar_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.bigint "project_id"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_milestones_on_project_id"
  end

  create_table "mmfs", force: :cascade do |t|
    t.decimal "amount"
    t.decimal "cancellation_amount"
    t.decimal "cancellation_penalty"
    t.datetime "cancelled_at"
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.string "dispatch_status"
    t.string "first_name"
    t.integer "fixed_period"
    t.string "id_number"
    t.string "last_name"
    t.string "merchant_request_id"
    t.string "mobile"
    t.string "mpesa_receipt"
    t.string "phone"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
  end

  create_table "momakevents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.text "event_details"
    t.string "image"
    t.integer "momak_id"
    t.integer "number_of_days"
    t.integer "number_of_nights"
    t.boolean "published"
    t.decimal "rate"
    t.date "start_date"
    t.datetime "updated_at", null: false
  end

  create_table "momakphotos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image"
    t.integer "momak_id"
    t.datetime "updated_at", null: false
  end

  create_table "momaks", force: :cascade do |t|
    t.string "adventure"
    t.string "country"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "momakphoto_id"
    t.string "photo1"
    t.string "specific_areas"
    t.date "start_date"
    t.string "town"
    t.datetime "updated_at", null: false
  end

  create_table "msessions", force: :cascade do |t|
    t.decimal "amount_due"
    t.decimal "amount_paid"
    t.decimal "balance"
    t.integer "counsellor_id"
    t.datetime "created_at", null: false
    t.integer "duration_minutes"
    t.time "end_time"
    t.string "intervention_used"
    t.boolean "is_final_session"
    t.integer "mbooking_id"
    t.integer "mood_after"
    t.integer "mood_before"
    t.boolean "paid"
    t.datetime "paid_at"
    t.string "payment_method"
    t.text "payment_notes"
    t.string "payment_status"
    t.text "presenting_issue"
    t.boolean "recommend_next_session"
    t.string "risk_level_after"
    t.date "session_date"
    t.text "session_notes"
    t.string "session_number"
    t.time "start_time"
    t.string "status"
    t.string "transaction_code"
    t.datetime "updated_at", null: false
    t.integer "verified_by_id"
    t.index ["counsellor_id"], name: "index_msessions_on_counsellor_id"
    t.index ["mbooking_id"], name: "index_msessions_on_mbooking_id"
    t.index ["payment_status"], name: "index_msessions_on_payment_status"
    t.index ["session_date"], name: "index_msessions_on_session_date"
    t.index ["status"], name: "index_msessions_on_status"
  end

  create_table "mtendelightpayments", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.string "merchant_request_id"
    t.string "mpesa_receipt"
    t.boolean "paid", default: false, null: false
    t.string "payment_id"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["checkout_request_id"], name: "index_mtendelightpayments_on_checkout_request_id", unique: true
    t.index ["merchant_request_id"], name: "index_mtendelightpayments_on_merchant_request_id"
    t.index ["payment_id"], name: "index_mtendelightpayments_on_payment_id"
    t.index ["phone"], name: "index_mtendelightpayments_on_phone"
    t.index ["status"], name: "index_mtendelightpayments_on_status"
  end

  create_table "mtendelightvideos", force: :cascade do |t|
    t.boolean "active", default: true
    t.boolean "charity", default: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured", default: false
    t.string "name"
    t.integer "position", default: 0
    t.boolean "spotlight", default: false
    t.datetime "updated_at", null: false
    t.string "video"
    t.string "video_public_id"
    t.boolean "volunteer", default: false
    t.boolean "walkwithher", default: false
  end

  create_table "mycustomers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "fullname"
    t.string "phone_number"
    t.datetime "updated_at", null: false
  end

  create_table "net_worth_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "item_type"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.decimal "value"
    t.index ["user_id"], name: "index_net_worth_items_on_user_id"
  end

  create_table "new_stocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "item_name"
    t.string "material_id"
    t.integer "quantity"
    t.string "uom"
    t.datetime "updated_at", null: false
  end

  create_table "niabnbs", force: :cascade do |t|
    t.bigint "ahoy_visit_id"
    t.string "airbnb_name"
    t.decimal "amount"
    t.string "area_name"
    t.boolean "available"
    t.integer "baths"
    t.integer "bedrooms"
    t.integer "beds"
    t.string "checkout_request_id"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "description"
    t.string "direction"
    t.string "email"
    t.datetime "end_date"
    t.integer "guests"
    t.integer "hid"
    t.integer "likes_count", default: 0
    t.string "location"
    t.string "mpesa_code"
    t.string "niaduration"
    t.bigint "niasale_id"
    t.string "payer_email"
    t.string "phone"
    t.string "photo1"
    t.decimal "price_per_night"
    t.boolean "promoted"
    t.boolean "publish"
    t.datetime "publish_date"
    t.decimal "rate"
    t.datetime "start_date"
    t.boolean "terms_accepted"
    t.datetime "updated_at", null: false
    t.decimal "usd"
    t.string "username"
    t.index ["niasale_id"], name: "index_niabnbs_on_niasale_id"
  end

  create_table "niabookings", force: :cascade do |t|
    t.string "alternative_contacts"
    t.decimal "budget_per_day"
    t.string "country_of_origin"
    t.string "country_visiting"
    t.datetime "created_at", null: false
    t.boolean "delivered"
    t.string "email"
    t.date "end_date"
    t.string "full_name"
    t.string "passport_id"
    t.string "phone_number"
    t.text "preferable_amenities"
    t.text "preferred_house_description"
    t.date "start_date"
    t.integer "total_number_of_guests"
    t.string "town_city"
    t.datetime "updated_at", null: false
  end

  create_table "niacategories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "parent_id"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_niacategories_on_slug", unique: true
  end

  create_table "niadurations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "niaorder_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "niaorder_id", null: false
    t.bigint "niaproduct_id", null: false
    t.decimal "price"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["niaorder_id"], name: "index_niaorder_items_on_niaorder_id"
    t.index ["niaproduct_id"], name: "index_niaorder_items_on_niaproduct_id"
  end

  create_table "niaorders", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.string "email"
    t.string "phone"
    t.string "status", default: "pending"
    t.boolean "stock_adjusted"
    t.boolean "stock_deducted"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_niaorders_on_user_id"
  end

  create_table "niaphotos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image"
    t.integer "niabnb_id"
    t.datetime "updated_at", null: false
  end

  create_table "niaproducts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image1"
    t.string "image2"
    t.string "image3"
    t.string "image4"
    t.string "images"
    t.string "name"
    t.bigint "niacategory_id", null: false
    t.decimal "price", default: "0.0"
    t.integer "stock", default: 0
    t.datetime "updated_at", null: false
    t.index ["niacategory_id"], name: "index_niaproducts_on_niacategory_id"
  end

  create_table "niasales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "id_no"
    t.string "phone_number"
    t.datetime "updated_at", null: false
  end

  create_table "noticeboards", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "notice_type"
    t.boolean "status"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "olts", force: :cascade do |t|
    t.string "caretaker"
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "latitude"
    t.string "location"
    t.decimal "longitude"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "openjobs", force: :cascade do |t|
    t.date "closing_date"
    t.string "company"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "job_name"
    t.string "location"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "opinions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "engaged"
    t.text "feedback"
    t.string "name"
    t.integer "rate"
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "menu_item_id"
    t.bigint "order_id"
    t.decimal "price"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_order_items_on_menu_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount"
    t.boolean "bank"
    t.string "barcode"
    t.string "branch"
    t.boolean "cash"
    t.string "code"
    t.datetime "created_at", null: false
    t.bigint "kitchen_status_id"
    t.boolean "mpesa"
    t.string "mpesaname"
    t.text "notes"
    t.string "orderid"
    t.bigint "table_id"
    t.decimal "total_price"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["kitchen_status_id"], name: "index_orders_on_kitchen_status_id"
    t.index ["table_id"], name: "index_orders_on_table_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "osps", force: :cascade do |t|
    t.text "challenge"
    t.text "clears"
    t.datetime "created_at", null: false
    t.datetime "escalated_time", precision: nil
    t.string "ffe_id"
    t.string "fme"
    t.string "inc"
    t.text "link_description"
    t.text "material_used"
    t.string "position_id"
    t.text "rca"
    t.string "service"
    t.string "service_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.datetime "uptime", precision: nil
    t.string "user_id"
    t.string "username"
  end

  create_table "ospslas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "month", precision: nil
    t.decimal "percentage"
    t.datetime "updated_at", null: false
  end

  create_table "partnerships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.bigint "mentorship_id"
    t.string "name"
    t.text "notes"
    t.string "partner_type"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["mentorship_id"], name: "index_partnerships_on_mentorship_id"
  end

  create_table "payment_durations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.string "mpesa_code"
    t.string "name"
    t.string "phone_number"
    t.datetime "posted_at", precision: nil
    t.string "transaction_id"
    t.datetime "updated_at", null: false
  end

  create_table "payroll_payrolls", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.bigint "employee_id"
    t.string "period"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_payroll_payrolls_on_company_id"
    t.index ["employee_id"], name: "index_payroll_payrolls_on_employee_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "parent_id"
    t.string "photo"
    t.string "role"
    t.integer "spouse_id"
    t.datetime "updated_at", null: false
  end

  create_table "pfs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "month", precision: nil
    t.integer "number"
    t.datetime "updated_at", null: false
  end

  create_table "pos_branches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.bigint "company_id"
    t.decimal "cost_price"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.decimal "price"
    t.string "sku"
    t.integer "stock"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date"
    t.string "name"
    t.date "start_date"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.integer "age"
    t.integer "amount"
    t.integer "amount_paid"
    t.string "body_type"
    t.datetime "created_at", null: false
    t.string "education_level"
    t.string "email"
    t.string "gender"
    t.string "height"
    t.text "interests"
    t.string "location"
    t.string "marital_status"
    t.bigint "match_request_id"
    t.integer "match_score"
    t.text "message"
    t.string "mpesa_reference"
    t.string "name"
    t.string "occupation"
    t.boolean "paid"
    t.datetime "paid_at"
    t.string "phone"
    t.string "phone_number"
    t.string "photo"
    t.boolean "proposal_received"
    t.string "religion"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "username"
    t.index ["match_request_id"], name: "index_proposals_on_match_request_id"
    t.index ["user_id"], name: "index_proposals_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "item_name"
    t.text "notes"
    t.date "purchase_date"
    t.integer "quantity"
    t.string "status"
    t.string "supplier"
    t.decimal "total_price"
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "question_type"
    t.bigint "survey_id"
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "real_estates", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.decimal "value"
    t.index ["user_id"], name: "index_real_estates_on_user_id"
  end

  create_table "reasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "region"
    t.datetime "updated_at", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.decimal "amount"
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.integer "momakevent_id"
    t.string "mpesa_code"
    t.integer "number_of_days"
    t.string "payment_method"
    t.string "phone_number"
    t.string "place"
    t.boolean "published"
    t.decimal "rate"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "username"
  end

  create_table "request_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "duration"
    t.string "ip"
    t.string "method"
    t.string "path"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "residentials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.bigint "question_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["question_id"], name: "index_responses_on_question_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sales_order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id"
    t.decimal "price"
    t.bigint "product_id"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_sales_order_items_on_order_id"
    t.index ["product_id"], name: "index_sales_order_items_on_product_id"
  end

  create_table "sales_orders", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "status"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["company_id"], name: "index_sales_orders_on_company_id"
    t.index ["customer_id"], name: "index_sales_orders_on_customer_id"
    t.index ["user_id"], name: "index_sales_orders_on_user_id"
  end

  create_table "sms_import_campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by"
    t.integer "failed"
    t.text "message"
    t.integer "sent"
    t.string "status"
    t.string "title"
    t.integer "total"
    t.datetime "updated_at", null: false
  end

  create_table "sms_import_recipients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error_message"
    t.string "name"
    t.string "phone"
    t.datetime "sent_at"
    t.bigint "sms_import_campaign_id"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["sms_import_campaign_id"], name: "index_sms_import_recipients_on_sms_import_campaign_id"
  end

  create_table "social_videos", force: :cascade do |t|
    t.string "caption"
    t.string "checksum"
    t.integer "comments"
    t.datetime "created_at", null: false
    t.string "external_id"
    t.integer "likes"
    t.boolean "matched"
    t.string "matched_video_id"
    t.string "platform"
    t.datetime "posted_at"
    t.integer "shares"
    t.string "status"
    t.text "thumbnail"
    t.datetime "updated_at", null: false
    t.string "video_id"
    t.text "video_url"
    t.integer "views"
    t.index ["matched"], name: "index_social_videos_on_matched"
    t.index ["platform", "video_id"], name: "index_social_videos_on_platform_and_video_id", unique: true
    t.index ["posted_at"], name: "index_social_videos_on_posted_at"
  end

  create_table "statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "stkpushes", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "modified_at"
    t.string "phone_number"
    t.datetime "updated_at", null: false
  end

  create_table "stks", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "modified_at"
    t.string "phone_number"
    t.datetime "updated_at", null: false
  end

  create_table "stock_movement_batches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "from_branch"
    t.jsonb "items_snapshot"
    t.date "movement_date"
    t.string "movement_type"
    t.text "note"
    t.string "source_type"
    t.string "status"
    t.integer "stock_movement_items_count", default: 0, null: false
    t.string "supplier_name"
    t.string "to_branch"
    t.datetime "updated_at", null: false
  end

  create_table "stock_movement_items", force: :cascade do |t|
    t.string "bale_name"
    t.datetime "created_at", null: false
    t.decimal "qty"
    t.bigint "stock_movement_batch_id"
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
    t.index ["stock_movement_batch_id"], name: "index_stock_movement_items_on_stock_movement_batch_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string "alt_phone"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "id_number"
    t.string "other_public_id"
    t.string "phone"
    t.string "resume"
    t.string "resume_public_id"
    t.text "resume_text"
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "daily"
    t.text "description"
    t.date "due_date"
    t.string "email"
    t.boolean "monthly"
    t.integer "position"
    t.boolean "reminder_sent", default: false
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "weekly"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "CRQ_number"
    t.string "SN_description"
    t.decimal "ci", precision: 50
    t.datetime "closed_time", precision: nil
    t.string "contractor_name"
    t.datetime "created_at", null: false
    t.string "crq_number"
    t.decimal "customer_MSISDN", precision: 50
    t.string "customer_email"
    t.string "customer_first_name"
    t.string "customer_last_name"
    t.decimal "customer_msisdn", precision: 50
    t.datetime "date", precision: nil
    t.string "drop_cable"
    t.datetime "duration", precision: nil
    t.string "estate_name"
    t.string "fat_port"
    t.string "fme_id"
    t.string "house_number"
    t.string "jc"
    t.string "lat"
    t.string "long"
    t.string "olt_port"
    t.string "pending_description"
    t.string "pending_reason"
    t.date "planned_date"
    t.string "poles"
    t.string "reason_id"
    t.string "region_id"
    t.string "registration_id"
    t.datetime "remedy_date", precision: nil
    t.string "residential_type"
    t.datetime "sale_date", precision: nil
    t.string "sn_description"
    t.string "splicer"
    t.string "splicer_id"
    t.string "splitter_no"
    t.string "splitter_port"
    t.string "status"
    t.string "status_id"
    t.string "subcon_id"
    t.string "tray"
    t.string "trunking"
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.string "username"
  end

  create_table "todos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "trends", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.integer "frequency"
    t.string "image_url"
    t.datetime "last_seen_at"
    t.string "name"
    t.string "platform"
    t.integer "popularity"
    t.float "score"
    t.integer "source_count"
    t.string "source_url"
    t.datetime "updated_at", null: false
  end

  create_table "tumapayments", force: :cascade do |t|
    t.decimal "amount"
    t.string "checkout_request_id"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.string "merchant_request_id"
    t.string "mpesa_receipt"
    t.string "payment_id"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "user_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "device"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "phone_number"
    t.string "pin"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.string "unique_session_id", limit: 20
    t.datetime "updated_at", null: false
    t.string "userdetails"
    t.string "username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "utilizes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crq_or_inc"
    t.text "description"
    t.string "ffe_id"
    t.string "item_name"
    t.string "material_id"
    t.integer "quantity"
    t.string "uom"
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type"
    t.text "object"
    t.string "whodunnit"
    t.string "{:null=>false}"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "votable_id"
    t.string "votable_type"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.bigint "voter_id"
    t.string "voter_type"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  add_foreign_key "accounting_accounts", "companies"
  add_foreign_key "accounting_journal_entries", "companies"
  add_foreign_key "accounting_journal_lines", "accounts"
  add_foreign_key "accounting_journal_lines", "journal_entries"
  add_foreign_key "accounts", "companies"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "aiconversations", "aicustomers"
  add_foreign_key "ailogs", "aicustomers"
  add_foreign_key "aimessages", "aiconversations"
  add_foreign_key "attendances", "companies"
  add_foreign_key "attendances", "employees"
  add_foreign_key "bookings", "momakevents"
  add_foreign_key "branches", "companies"
  add_foreign_key "businesses", "blocks"
  add_foreign_key "cinvoice_items", "cinvoices"
  add_foreign_key "cinvoices", "contractors"
  add_foreign_key "comments", "niabnbs"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "core_activity_logs", "users"
  add_foreign_key "core_branches", "companies"
  add_foreign_key "core_events", "users"
  add_foreign_key "core_notifications", "users"
  add_foreign_key "cpayments", "cinvoices"
  add_foreign_key "crm_customers", "companies"
  add_foreign_key "crm_leads", "companies"
  add_foreign_key "cstatements", "contractors"
  add_foreign_key "daily_tasks", "users"
  add_foreign_key "dispatchmmfs", "mmfs"
  add_foreign_key "dsa_sales", "dsas"
  add_foreign_key "employees", "companies"
  add_foreign_key "events", "users"
  add_foreign_key "expenditures", "categories"
  add_foreign_key "expenditures", "payment_methods"
  add_foreign_key "hr_attendances", "employees"
  add_foreign_key "hr_employees", "companies"
  add_foreign_key "hr_employees", "users"
  add_foreign_key "ict_issuances", "users"
  add_foreign_key "inventory_products", "companies"
  add_foreign_key "inventory_stock_movements", "branches"
  add_foreign_key "inventory_stock_movements", "companies"
  add_foreign_key "inventory_stock_movements", "products"
  add_foreign_key "janomax_bale_items", "jbales"
  add_foreign_key "janomax_bale_openings", "jbales"
  add_foreign_key "janomax_bales", "companies"
  add_foreign_key "janomax_outbound_calls", "janomaxleads"
  add_foreign_key "janomaxes", "jcustomers"
  add_foreign_key "janomaxes", "jmcustomers"
  add_foreign_key "janomaxleadcalls", "janomaxleads"
  add_foreign_key "janomaxleads", "jmcustomers"
  add_foreign_key "jbales", "jcategories"
  add_foreign_key "jbudget_expenses", "jbudgets"
  add_foreign_key "jdeliveries", "jorders"
  add_foreign_key "jevents", "jcalendars"
  add_foreign_key "jfulfillments", "jmcustomers"
  add_foreign_key "jmcallcomments", "jmcustomers"
  add_foreign_key "jmcustomer_items", "janomaxes"
  add_foreign_key "jmcustomer_items", "jmcustomers"
  add_foreign_key "jmcustomer_items", "jstocks"
  add_foreign_key "jmcustomers", "jmleads"
  add_foreign_key "jmleads", "jmcustomers"
  add_foreign_key "jmleads", "jstaffs"
  add_foreign_key "jmpayments", "jmcustomers"
  add_foreign_key "jmreward_redemptions", "jmcustomers"
  add_foreign_key "job_applications", "openjobs"
  add_foreign_key "job_applications", "talents"
  add_foreign_key "jorder_items", "jbales"
  add_foreign_key "jorder_items", "jorders"
  add_foreign_key "jorders", "jbranches"
  add_foreign_key "journal_entries", "companies"
  add_foreign_key "journal_lines", "accounts"
  add_foreign_key "journal_lines", "journal_entries"
  add_foreign_key "jpartialstocks", "jstocks"
  add_foreign_key "m_adventure_hotels", "m_adventures"
  add_foreign_key "m_adventure_hotels", "m_hotels"
  add_foreign_key "m_bookings", "m_adventures"
  add_foreign_key "m_customers", "airbnbs"
  add_foreign_key "m_invoice_items", "m_invoices"
  add_foreign_key "m_invoices", "m_pos"
  add_foreign_key "m_invoices", "m_subcontractors"
  add_foreign_key "m_payments", "m_invoices"
  add_foreign_key "m_payments", "m_subcontractors"
  add_foreign_key "m_payrolls", "m_employees"
  add_foreign_key "m_po_items", "m_pos"
  add_foreign_key "m_pos", "m_subcontractors"
  add_foreign_key "m_statements", "m_subcontractors"
  add_foreign_key "m_time_offs", "m_employees"
  add_foreign_key "m_transactions", "m_accounts"
  add_foreign_key "match_requests", "users"
  add_foreign_key "mattendances", "mentorships"
  add_foreign_key "mbookings", "counsellors"
  add_foreign_key "mcomments", "projects"
  add_foreign_key "mcomments", "users"
  add_foreign_key "mcontacts", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "mevents", "mcalendars"
  add_foreign_key "milestones", "projects"
  add_foreign_key "net_worth_items", "users"
  add_foreign_key "niabnbs", "niasales"
  add_foreign_key "niaorder_items", "niaorders"
  add_foreign_key "niaorder_items", "niaproducts"
  add_foreign_key "niaorders", "users"
  add_foreign_key "niaproducts", "niacategories"
  add_foreign_key "order_items", "menu_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "kitchen_statuses"
  add_foreign_key "orders", "tables"
  add_foreign_key "orders", "users"
  add_foreign_key "partnerships", "mentorships"
  add_foreign_key "payroll_payrolls", "companies"
  add_foreign_key "payroll_payrolls", "employees"
  add_foreign_key "products", "companies"
  add_foreign_key "projects", "users"
  add_foreign_key "proposals", "match_requests"
  add_foreign_key "proposals", "users"
  add_foreign_key "questions", "surveys"
  add_foreign_key "real_estates", "users"
  add_foreign_key "responses", "questions"
  add_foreign_key "responses", "users"
  add_foreign_key "sales_order_items", "orders"
  add_foreign_key "sales_order_items", "products"
  add_foreign_key "sales_orders", "companies"
  add_foreign_key "sales_orders", "customers"
  add_foreign_key "sales_orders", "users"
  add_foreign_key "sms_import_recipients", "sms_import_campaigns"
  add_foreign_key "stock_movement_items", "stock_movement_batches"
  add_foreign_key "surveys", "users"
end
