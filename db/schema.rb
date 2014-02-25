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

ActiveRecord::Schema.define(version: 20140225030519) do

  create_table "contributions", force: true do |t|
    t.integer  "contributor_id"
    t.integer  "user_id"
    t.integer  "need_id"
    t.integer  "cents"
    t.string   "stripe_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "contributors", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "needs", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id_posted_by"
    t.integer  "user_id_church_admin"
    t.integer  "need_stage"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "social_security_number"
    t.string   "street_address"
    t.string   "drivers_license"
    t.integer  "age"
    t.integer  "gender"
    t.string   "title_public"
    t.text     "description_public"
    t.boolean  "is_public"
  end

  add_index "needs", ["age"], name: "index_needs_on_age"
  add_index "needs", ["description_public"], name: "index_needs_on_description_public"
  add_index "needs", ["drivers_license"], name: "index_needs_on_drivers_license"
  add_index "needs", ["first_name"], name: "index_needs_on_first_name"
  add_index "needs", ["gender"], name: "index_needs_on_gender"
  add_index "needs", ["is_public"], name: "index_needs_on_is_public"
  add_index "needs", ["last_name"], name: "index_needs_on_last_name"
  add_index "needs", ["need_stage"], name: "index_needs_on_need_stage"
  add_index "needs", ["social_security_number"], name: "index_needs_on_social_security_number"
  add_index "needs", ["street_address"], name: "index_needs_on_street_address"
  add_index "needs", ["title_public"], name: "index_needs_on_title_public"
  add_index "needs", ["user_id_church_admin"], name: "index_needs_on_user_id_church_admin"
  add_index "needs", ["user_id_posted_by"], name: "index_needs_on_user_id_posted_by"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
