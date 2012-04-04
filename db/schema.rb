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

ActiveRecord::Schema.define(:version => 20120402185651) do

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "authorization_id", :null => false
    t.string   "access_token",     :null => false
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_authorization_codes", :force => true do |t|
    t.integer  "authorization_id", :null => false
    t.string   "code",             :null => false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "redirect_uri"
  end

  create_table "oauth_authorizations", :force => true do |t|
    t.integer  "client_id",           :null => false
    t.integer  "resource_owner_id"
    t.string   "resource_owner_type"
    t.string   "scope"
    t.datetime "expires_at"
  end

  create_table "oauth_clients", :force => true do |t|
    t.string  "name"
    t.string  "oauth_identifier",                      :null => false
    t.string  "oauth_secret",                          :null => false
    t.string  "oauth_redirect_uri"
    t.boolean "trusted",            :default => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "template_type"
    t.text     "content"
    t.integer  "oauth_client_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.hstore   "data"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
