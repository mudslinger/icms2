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

ActiveRecord::Schema.define(:version => 20130321082141) do

  create_table "action_logs", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "action_logs", ["created_at"], :name => "index_action_logs_on_created_at"

  create_table "app_configs", :force => true do |t|
    t.datetime "cron1_triggered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "memo"
    t.integer  "form_id"
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id", :null => false
    t.datetime "date_begin"
    t.datetime "date_end"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["date_begin"], :name => "index_entries_on_date_begin"
  add_index "entries", ["date_end"], :name => "index_entries_on_date_end"
  add_index "entries", ["form_id"], :name => "index_entries_on_form_id"

  create_table "entry_metas", :force => true do |t|
    t.integer  "entry_id",                     :null => false
    t.integer  "field_id",                     :null => false
    t.string   "string_value", :limit => 1024
    t.text     "text_value"
    t.integer  "int_value"
    t.float    "float_value"
    t.string   "file_value",   :limit => 4096
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_value"
  end

  add_index "entry_metas", ["entry_id", "field_id"], :name => "index_entry_metas_on_entry_id_and_field_id", :unique => true

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "entry_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorites", ["user_id", "entry_id"], :name => "index_favorites_on_user_id_and_entry_id", :unique => true

  create_table "fields", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "label"
    t.text     "description"
    t.integer  "form_id"
    t.integer  "required"
    t.string   "default"
    t.string   "ftype"
    t.string   "options"
    t.string   "sortkey"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "options2"
  end

  add_index "fields", ["form_id", "name"], :name => "index_fields_on_form_id_and_name", :unique => true

  create_table "form_permissions", :force => true do |t|
    t.integer  "form_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_permissions", ["form_id"], :name => "index_form_permissions_on_form_id"
  add_index "form_permissions", ["user_id"], :name => "index_form_permissions_on_user_id"

  create_table "forms", :force => true do |t|
    t.string   "title",                               :null => false
    t.text     "comment"
    t.string   "template_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_content_field", :default => true
  end

  create_table "libraries", :force => true do |t|
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id", :null => false
    t.integer  "entry_id"
    t.string   "libtype"
    t.string   "label"
    t.string   "description"
    t.string   "file_name"
    t.string   "file_name_ext"
    t.string   "file_path"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "memo"
    t.integer  "entry_id"
    t.integer  "form_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "mailaddress"
    t.string   "ipaddress"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_profiles", :force => true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "address"
    t.string   "avatar"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "name",                               :null => false
    t.integer  "user_level",          :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "emailaddress"
    t.string   "user_agent"
    t.string   "fb_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
