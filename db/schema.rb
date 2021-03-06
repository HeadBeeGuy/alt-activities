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

ActiveRecord::Schema.define(version: 2021_06_16_011200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.text "short_description"
    t.text "long_description"
    t.string "time_estimate"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "upvote_count", default: 0
    t.boolean "checked", default: true
    t.boolean "workshop", default: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_links", force: :cascade do |t|
    t.integer "original_id"
    t.integer "inspired_id"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspired_id"], name: "index_activity_links_on_inspired_id"
    t.index ["original_id", "inspired_id"], name: "index_activity_links_on_original_id_and_inspired_id", unique: true
    t.index ["original_id"], name: "index_activity_links_on_original_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "englipedia_activities", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "submission_date"
    t.string "estimated_time"
    t.string "original_url"
    t.text "attached_files", default: [], array: true
    t.boolean "warmup"
    t.boolean "es"
    t.boolean "jhs"
    t.boolean "hs"
    t.boolean "speaking"
    t.boolean "listening"
    t.boolean "reading"
    t.boolean "writing"
    t.text "outline"
    t.text "description"
    t.boolean "converted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "front_page_posts", force: :cascade do |t|
    t.text "title"
    t.text "excerpt"
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_front_page_posts_on_user_id"
  end

  create_table "tag_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "instruction"
    t.integer "suggested_max", default: 0
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "tag_id"], name: "index_taggings_on_activity_id_and_tag_id", unique: true
    t.index ["activity_id"], name: "index_taggings_on_activity_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "short_name"
    t.string "long_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag_category_id"
    t.string "name"
    t.text "explanation"
    t.index ["short_name"], name: "index_tags_on_short_name"
  end

  create_table "textbook_page_links", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "textbook_page_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_textbook_page_links_on_activity_id"
    t.index ["textbook_page_id"], name: "index_textbook_page_links_on_textbook_page_id"
  end

  create_table "textbook_pages", force: :cascade do |t|
    t.bigint "textbook_id"
    t.integer "page"
    t.text "description"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_textbook_pages_on_tag_id"
    t.index ["textbook_id"], name: "index_textbook_pages_on_textbook_id"
  end

  create_table "textbooks", force: :cascade do |t|
    t.string "name"
    t.text "additional_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 0
    t.integer "year_published"
    t.boolean "current", default: true
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_upvotes_on_activity_id"
    t.index ["user_id", "activity_id"], name: "index_upvotes_on_user_id_and_activity_id", unique: true
    t.index ["user_id"], name: "index_upvotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role", default: 1
    t.string "home_country"
    t.string "location"
    t.text "bio"
    t.integer "activity_count", default: 0
    t.string "unconfirmed_email"
    t.boolean "trusted", default: false
    t.string "teaching_history"
    t.string "offsite_link"
    t.boolean "initial_premium", default: false, null: false
    t.boolean "display_favorites", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "front_page_posts", "users"
  add_foreign_key "textbook_page_links", "activities"
  add_foreign_key "textbook_page_links", "textbook_pages"
  add_foreign_key "textbook_pages", "tags"
  add_foreign_key "textbook_pages", "textbooks"
end
