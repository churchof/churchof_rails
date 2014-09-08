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

ActiveRecord::Schema.define(version: 20140907184640) do

  create_table "activities", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "user_id"
    t.text     "description"
  end

  create_table "contributions", force: true do |t|
    t.integer  "contributor_id"
    t.integer  "user_id"
    t.integer  "need_id"
    t.string   "stripe_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "amount_cents"
    t.boolean  "succeded"
    t.boolean  "reimbursed"
  end

  create_table "contributors", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demographics", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "icon_url"
  end

  create_table "demographics_resources", force: true do |t|
    t.integer "demographic_id"
    t.integer "resource_id"
  end

  create_table "expenses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "documentation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "need_id"
    t.integer  "amount_cents"
  end

  add_index "expenses", ["need_id"], name: "index_expenses_on_need_id"

  create_table "images", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "update_id"
    t.text     "caption"
  end

  add_index "images", ["update_id"], name: "index_images_on_update_id"

  create_table "initiative_metrics", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "initiative_id"
  end

  create_table "initiatives", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
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
    t.string   "street_address"
    t.string   "drivers_license"
    t.integer  "gender"
    t.string   "title_public"
    t.text     "description_public"
    t.boolean  "is_public"
    t.integer  "recipient_size",                                                        default: 1
    t.integer  "frequency_type",                                                        default: 1
    t.text     "recipient_contribution"
    t.string   "date_of_birth"
    t.string   "full_street_address"
    t.string   "last_four_ssn",                     limit: 4
    t.decimal  "latitude",                                    precision: 15, scale: 10
    t.decimal  "longitude",                                   precision: 15, scale: 10
    t.decimal  "approx_latitude",                             precision: 15, scale: 10
    t.decimal  "approx_longitude",                            precision: 15, scale: 10
    t.boolean  "shows_real_location_publically"
    t.datetime "date_public_posted"
    t.integer  "volunteersNeededCount"
    t.integer  "additionalVolunteersSignedUpCount"
    t.datetime "volunteerTime"
    t.string   "volunteerLocation"
    t.string   "volunteerDescription"
    t.integer  "user_id_need_leader"
    t.datetime "completion_goal_date"
    t.integer  "rosm_request_id"
  end

  add_index "needs", ["description_public"], name: "index_needs_on_description_public"
  add_index "needs", ["drivers_license"], name: "index_needs_on_drivers_license"
  add_index "needs", ["first_name"], name: "index_needs_on_first_name"
  add_index "needs", ["frequency_type"], name: "index_needs_on_frequency_type"
  add_index "needs", ["gender"], name: "index_needs_on_gender"
  add_index "needs", ["is_public"], name: "index_needs_on_is_public"
  add_index "needs", ["last_name"], name: "index_needs_on_last_name"
  add_index "needs", ["need_stage"], name: "index_needs_on_need_stage"
  add_index "needs", ["recipient_size"], name: "index_needs_on_recipient_size"
  add_index "needs", ["street_address"], name: "index_needs_on_street_address"
  add_index "needs", ["title_public"], name: "index_needs_on_title_public"
  add_index "needs", ["user_id_church_admin"], name: "index_needs_on_user_id_church_admin"
  add_index "needs", ["user_id_need_leader"], name: "index_needs_on_user_id_need_leader"
  add_index "needs", ["user_id_posted_by"], name: "index_needs_on_user_id_posted_by"

  create_table "needs_skills", force: true do |t|
    t.integer "need_id"
    t.integer "skill_id"
  end

  create_table "organization_roles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "role_type"
    t.boolean  "pending"
  end

  create_table "organizations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.string   "address"
    t.decimal  "latitude",          precision: 15, scale: 10
    t.decimal  "longitude",         precision: 15, scale: 10
    t.integer  "organization_type"
    t.string   "website_url"
  end

  create_table "resource_events", force: true do |t|
    t.integer "resource_id"
    t.text    "schedule"
    t.time    "start_time"
    t.time    "end_time"
  end

  create_table "resource_flags", force: true do |t|
    t.integer "resource_id"
    t.integer "user_id_church_admin"
    t.boolean "flagged"
  end

  create_table "resources", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.string   "website"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.integer  "user_id"
    t.integer  "availability_status"
    t.string   "status"
    t.string   "address"
    t.decimal  "latitude",            precision: 15, scale: 10
    t.decimal  "longitude",           precision: 15, scale: 10
    t.integer  "organization_id"
    t.integer  "public_status"
    t.boolean  "flagged",                                       default: false
  end

  create_table "resources_skills", force: true do |t|
    t.integer "resource_id"
    t.integer "skill_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "skills", force: true do |t|
    t.text     "description"
    t.string   "icon_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "initiative_id"
  end

  create_table "skills_users", force: true do |t|
    t.integer "skill_id"
    t.integer "user_id"
  end

  create_table "time_contributions", force: true do |t|
    t.integer  "user_id"
    t.integer  "need_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cancelled"
  end

  create_table "updates", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "need_id"
  end

  add_index "updates", ["need_id"], name: "index_updates_on_need_id"

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
    t.boolean  "is_full_rosm_member"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
