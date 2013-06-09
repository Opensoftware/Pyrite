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

ActiveRecord::Schema.define(:version => 20130529191327) do

  create_table "academic_year_events", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "lecture_free"
    t.integer  "academic_year_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "academic_years", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "block_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "short_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "blocks", :force => true do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer  "lecturer_id"
    t.integer  "event_id"
    t.integer  "room_id"
    t.integer  "building_id"
    t.integer  "block_type_id"
    t.string   "name"
    t.text     "comments"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "blocks_groups", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "block_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "buildings", :force => true do |t|
    t.string   "nazwa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "nazwa"
    t.string   "nazwa_f"
    t.string   "wydzial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "freedays", :force => true do |t|
    t.datetime "start"
    t.datetime "stop"
    t.string   "nazwa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "nazwa"
    t.integer  "liczba"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rok"
    t.string   "kurs"
    t.string   "kierunek"
    t.integer  "grupa"
    t.integer  "podgrupa"
  end

  create_table "groups_plans", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lecturers", :force => true do |t|
    t.string   "title"
    t.string   "lecture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_plans", :force => true do |t|
    t.string   "godz"
    t.string   "dni"
    t.string   "prowadzacy"
    t.string   "budynek"
    t.integer  "sala"
    t.string   "katedra"
    t.string   "grupa"
    t.string   "przedmiot"
    t.string   "rodzaj"
    t.integer  "dlugosc"
    t.integer  "czestotliwosc"
    t.string   "uwagi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_plans", :force => true do |t|
    t.string   "godz"
    t.string   "dni"
    t.string   "prowadzacy"
    t.string   "budynek"
    t.integer  "sala"
    t.string   "katedra"
    t.string   "grupa"
    t.string   "przedmiot"
    t.string   "rodzaj"
    t.integer  "dlugosc"
    t.integer  "czestotliwosc"
    t.string   "uwagi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "godz"
    t.string   "dni"
    t.string   "prowadzacy"
    t.string   "budynek"
    t.string   "sala"
    t.string   "katedra"
    t.string   "grupa"
    t.string   "przedmiot"
    t.string   "rodzaj"
    t.integer  "dlugosc"
    t.integer  "czestotliwosc"
    t.string   "uwagi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "wazneod"
    t.date     "waznedo"
    t.integer  "plan_id",       :default => 0, :null => false
  end

  create_table "reservations", :force => true do |t|
    t.string   "godz"
    t.string   "dni"
    t.string   "prowadzacy"
    t.string   "budynek"
    t.string   "sala"
    t.string   "grupa"
    t.string   "przedmiot"
    t.string   "rodzaj"
    t.integer  "dlugosc"
    t.datetime "waznosc"
    t.string   "uwagi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "numer"
    t.string   "opiekun"
    t.string   "rodzaj"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ilosc_miejsc"
    t.integer  "budynek_id"
    t.text     "uwagi"
  end

  create_table "schedules", :force => true do |t|
    t.string   "nazwa"
    t.string   "rok"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.integer  "current_plan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_to_edit"
    t.string   "unit_name"
    t.string   "email_contact"
  end

  create_table "subjects", :force => true do |t|
    t.string   "nazwa"
    t.string   "katedra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
