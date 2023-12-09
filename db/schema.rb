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

ActiveRecord::Schema[7.0].define(version: 2023_12_09_000555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "careers_page_url"
    t.string "scraper_class"
  end

  create_table "job_previews", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "location"
    t.string "company"
    t.string "filter_details"
    t.string "status"
    t.datetime "created_at", precision: nil
    t.string "source"
    t.string "searched_location"
    t.integer "filter_reason"
    t.string "sanitized_location"
  end

  create_table "job_technologies", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "technology_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "title_matches"
    t.integer "description_matches"
    t.boolean "main_technology", default: false
    t.index ["job_id"], name: "index_job_technologies_on_job_id"
    t.index ["technology_id"], name: "index_job_technologies_on_technology_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.decimal "longitude"
    t.decimal "latitude"
    t.text "description"
    t.string "source"
    t.string "source_id"
    t.string "status"
    t.string "company"
    t.string "filter_details"
    t.bigint "company_id", null: false
    t.string "scraped_company"
    t.string "remote_status"
    t.integer "filter_reason"
    t.json "job_posting_schema"
    t.bigint "job_preview_id"
    t.boolean "live_on_careers_site"
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["job_preview_id"], name: "index_jobs_on_job_preview_id"
  end

  create_table "property_transactions", force: :cascade do |t|
    t.string "searched_url"
    t.string "searched_postcode"
    t.string "url"
    t.string "address"
    t.string "date_of_sale"
    t.string "num_of_bedrooms"
    t.string "num_of_bathrooms"
    t.string "property_type"
    t.string "price"
    t.string "key_features_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.text "aliases"
    t.boolean "is_language"
    t.boolean "is_framework"
    t.boolean "used_for_frontend"
    t.boolean "used_for_backend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "job_previews", on_delete: :nullify
  add_foreign_key "taggings", "tags"
end
