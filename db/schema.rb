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

ActiveRecord::Schema.define(version: 20150203005027) do

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
  end

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
  end

end
