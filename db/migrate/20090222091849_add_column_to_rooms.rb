class AddColumnToRooms < ActiveRecord::Migration
  def self.up
		add_column :rooms, :ilosc_miejsc, :integer
		add_column :rooms, :budynek_id, :integer
		add_column :rooms, :uwagi, :integer
  end

  def self.down
		remove_column :rooms, :ilosc_miejsc
		remove_column :rooms, :budynek_id
		remove_column :rooms, :uwagi
  end
end
