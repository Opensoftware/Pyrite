class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.column :name, :string
      t.decimal :latitude, :precision=> 10, :scale=> 6
      t.decimal :longitude, :precision=> 10, :scale=> 6
      t.string :address
      t.timestamps
    end
  end

  def self.down
    drop_table :buildings
  end
end
