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

ActiveRecord::Schema.define(version: 20150404194634) do

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connected_grievance_associations", force: :cascade do |t|
    t.integer  "grievance_id"
    t.integer  "connected_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cops", force: :cascade do |t|
    t.integer  "state_id"
    t.integer  "city_id"
    t.string   "name"
    t.string   "badge_number"
    t.string   "race"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "text_search"
  end

  create_table "grievances", force: :cascade do |t|
    t.integer  "state_id"
    t.integer  "city_id"
    t.integer  "cop_id"
    t.date     "date_incident"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "revision_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "title"
    t.text     "text_search"
    t.string   "cop_name"
    t.string   "city_name"
    t.string   "state_name"
    t.boolean  "publish_user_race", default: true
    t.boolean  "publish_user_age",  default: true
    t.boolean  "visible",           default: false
    t.boolean  "is_new",            default: true
    t.boolean  "is_revision",       default: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "race"
    t.integer  "city_id"
    t.integer  "state_id"
    t.string   "age"
    t.boolean  "is_admin",               default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
