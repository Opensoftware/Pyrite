class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.column "numer", :string
      t.column "opiekun", :string
      t.column "godz", :string
      t.column "dni", :string
      t.column "rodzaj", :string

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
