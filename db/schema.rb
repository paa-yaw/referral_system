# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170418020650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.string   "user_action"
    t.string   "company_action"
    t.string   "jd_action"
    t.string   "requirement_action"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "posted",             default: false
  end

  add_index "activities", ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.string   "clientname"
    t.string   "email"
    t.string   "role"
    t.string   "phonenumber"
    t.string   "url"
    t.text     "about"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "update_button", default: false
    t.boolean  "contacted",     default: false
    t.boolean  "deal",          default: false
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "job_descriptions", force: :cascade do |t|
    t.string   "job_title"
    t.integer  "experience"
    t.decimal  "min_salary"
    t.decimal  "max_salary"
    t.integer  "vacancies"
    t.boolean  "update_button"
    t.integer  "company_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "job_descriptions", ["company_id"], name: "index_job_descriptions_on_company_id", using: :btree

  create_table "requirements", force: :cascade do |t|
    t.text     "content"
    t.boolean  "update_button"
    t.integer  "job_description_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "requirements", ["job_description_id"], name: "index_requirements_on_job_description_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",           null: false
    t.string   "encrypted_password",     default: "",           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "username",               default: "Guest User"
    t.boolean  "admin",                  default: false
    t.integer  "admin_status",           default: 0
    t.boolean  "update_button",          default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "companies", "users"
  add_foreign_key "job_descriptions", "companies"
  add_foreign_key "requirements", "job_descriptions"
end
