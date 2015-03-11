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

ActiveRecord::Schema.define(version: 20150311160736) do

  create_table "following_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", force: true do |t|
    t.integer  "user_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "invitee_id"
    t.integer  "attending",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "sessions" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "statuses", force: true do |t|
    t.string   "body"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media_key"
    t.integer  "media_type", default: 0
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "phone_number"
    t.string   "display_name"
    t.integer  "availability",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "private_profile", default: false
  end

  create_table "waves", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "place"
    t.string   "location"
    t.datetime "time"
    t.boolean  "private",     default: true
    t.integer  "degrees"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
