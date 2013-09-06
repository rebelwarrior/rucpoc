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

ActiveRecord::Schema.define(version: 20130906182347) do

  create_table "collections", force: true do |t|
    t.string   "internal_invoice_number"
    t.decimal  "amount_owed"
    t.boolean  "paid?",                           default: false
    t.integer  "collection_payment_id_number"
    t.string   "collection_payment_emmiter_info"
    t.string   "transaction_contact_person"
    t.string   "notes"
    t.string   "bounced_check_bank"
    t.string   "bounced_check_number"
    t.integer  "debtor_id"
    t.boolean  "being_processed?",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["internal_invoice_number"], name: "index_collections_on_internal_invoice_number"

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
    t.boolean  "supervisor",      default: false
    t.string   "work_area"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
