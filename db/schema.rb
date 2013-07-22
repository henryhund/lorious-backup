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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130722205847) do

  create_table "appointments", :force => true do |t|
    t.integer  "host_id"
    t.integer  "attendee_id"
    t.datetime "time"
    t.boolean  "completed"
    t.integer  "length"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "chat_key"
    t.string   "chat_session_id"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "expertise"
    t.string   "interest"
    t.decimal  "expertise_hourly",  :precision => 8, :scale => 2
    t.decimal  "interest_hourly",   :precision => 8, :scale => 2
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "niche"
    t.string   "tagline"
    t.text     "bio"
    t.string   "availability"
    t.string   "privacy",                                         :default => "private"
    t.string   "name_display_type",                               :default => "long"
    t.string   "display_name"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "requests", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "expertise"
    t.string   "help_needed"
    t.string   "time_needed"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.text     "status"
    t.string   "horizon"
    t.integer  "profile_id"
    t.string   "request_type"
    t.boolean  "finished",                                   :default => false
    t.decimal  "max_rate",     :precision => 8, :scale => 2
  end

  create_table "reviews", :force => true do |t|
    t.integer  "appointment_id"
    t.integer  "reviewer_id"
    t.integer  "reviewee_id"
    t.decimal  "rating",         :precision => 2, :scale => 1
    t.text     "content"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "reviews", ["appointment_id"], :name => "index_reviews_on_appointment_id"
  add_index "reviews", ["reviewee_id"], :name => "index_reviews_on_reviewee_id"
  add_index "reviews", ["reviewer_id"], :name => "index_reviews_on_reviewer_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "session_records", :force => true do |t|
    t.string   "chat_session_id"
    t.integer  "user_id_1"
    t.integer  "user_id_2"
    t.datetime "disconnected_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.string   "unconfirmed_email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "fully_registered",       :default => false
    t.string   "slug"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "username"
    t.boolean  "expert",                 :default => false
    t.string   "stripe_customer_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
