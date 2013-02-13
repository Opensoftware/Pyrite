class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
    t.column "godz", :string
    t.column "dni", :string 
    t.column "prowadzacy", :string
    t.column "budynek", :string
    t.column "sala", :integer
    t.column "katedra", :string
    t.column "grupa", :string
    t.column "przedmiot", :string
    t.column "rodzaj", :string
    t.column "dlugosc", :integer
    t.column "czestotliwosc", :integer 
    t.column "uwagi", :string
    t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
