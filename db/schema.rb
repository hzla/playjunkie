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

ActiveRecord::Schema.define(version: 20170313025404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "authorizations", force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "unique_id"
    t.index ["unique_id"], name: "index_authorizations_on_unique_id", using: :btree
    t.index ["user_id"], name: "index_authorizations_on_user_id", using: :btree
  end

  create_table "item_answers", force: :cascade do |t|
    t.text     "answer_text"
    t.string   "image_credit"
    t.integer  "result_id"
    t.integer  "quiz_item_id"
    t.boolean  "correct?"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "image"
    t.string   "remember_code"
    t.string   "image_key"
  end

  create_table "quiz_items", force: :cascade do |t|
    t.string   "title"
    t.string   "image_credit"
    t.string   "image_credit_back"
    t.string   "color"
    t.string   "color_back"
    t.text     "item_text"
    t.integer  "quiz_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "image"
    t.text     "item_text_back"
    t.string   "image_back"
    t.string   "remember_code"
    t.integer  "order"
    t.string   "answer_style"
    t.string   "image_key"
    t.string   "image_key_back"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "completion_message"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image"
    t.boolean  "published",          default: false
    t.string   "quiz_type"
    t.integer  "user_id"
    t.datetime "publish_date"
    t.boolean  "is_preview?"
    t.integer  "view_count",         default: 0
    t.boolean  "featured",           default: false
    t.boolean  "homepage_pick",      default: false
    t.boolean  "browse_pick",        default: false
    t.integer  "view_count_1",       default: 0
    t.integer  "view_count_2",       default: 0
    t.integer  "view_count_3",       default: 0
    t.integer  "view_count_4",       default: 0
    t.integer  "view_count_5",       default: 0
    t.integer  "view_count_6",       default: 0
    t.integer  "view_count_7",       default: 0
    t.integer  "trending_count",     default: 0
    t.string   "image_key"
  end

  create_table "results", force: :cascade do |t|
    t.text     "result_text"
    t.string   "image_credit"
    t.string   "range"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "image"
    t.integer  "quiz_id"
    t.integer  "range_min"
    t.integer  "range_max"
    t.string   "remember_code"
    t.string   "image_key"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.text     "description"
    t.string   "profile_pic_url"
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
    t.boolean  "is_admin?",                      default: false
    t.boolean  "is_banned?"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

end
