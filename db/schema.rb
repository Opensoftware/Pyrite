# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090308184329) do

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
    t.integer  "uwagi"
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
  end

  create_table "subjects", :force => true do |t|
    t.string   "nazwa"
    t.string   "katedra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
