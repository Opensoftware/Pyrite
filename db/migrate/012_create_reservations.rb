class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
    t.column "godz", :string
    t.column "dni", :string
    t.column "prowadzacy", :string
    t.column "budynek", :string
    t.column "sala", :integer
    t.column "grupa", :string
    t.column "przedmiot", :string
    t.column "rodzaj", :string
    t.column "dlugosc", :int
    t.column "waznosc", :datetime
    t.column "uwagi", :string
    t.timestamps

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
