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

ActiveRecord::Schema.define(version: 20150303192926) do

  create_table "lines", force: true do |t|
    t.string   "tc_in"
    t.string   "tc_out"
    t.text     "text"
    t.integer  "n"
    t.text     "note"
    t.string   "tag"
    t.integer  "transcript_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["transcript_id"], name: "index_lines_on_transcript_id"

  create_table "papercuts", force: true do |t|
    t.integer  "position"
    t.integer  "line_id"
    t.integer  "paperedit_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papercuts", ["line_id"], name: "index_papercuts_on_line_id"
  add_index "papercuts", ["paperedit_id"], name: "index_papercuts_on_paperedit_id"

  create_table "paperedits", force: true do |t|
    t.string   "projectname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "paperedits", ["user_id"], name: "index_paperedits_on_user_id"

  create_table "transcripts", force: true do |t|
    t.string   "filename"
    t.string   "name"
    t.string   "speakername"
    t.string   "date"
    t.string   "youtubeurl"
    t.string   "reel"
    t.string   "tc_meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "transcripts", ["user_id"], name: "index_transcripts_on_user_id"

  create_table "users", force: true do |t|
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
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
