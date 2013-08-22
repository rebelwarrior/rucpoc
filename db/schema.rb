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

ActiveRecord::Schema.define(version: 20130822142828) do

  create_table "debtors", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "tel"
    t.string   "address"
    t.string   "location"
    t.string   "contact_person"
    t.string   "employer_id_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debtors", ["employer_id_number"], name: "index_debtors_on_employer_id_number"
  add_index "debtors", ["name"], name: "index_debtors_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
