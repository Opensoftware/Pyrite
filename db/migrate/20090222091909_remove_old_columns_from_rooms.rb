class RemoveOldColumnsFromRooms < ActiveRecord::Migration
  def self.up
		remove_column :rooms, :godz
		remove_column :rooms, :dni
  end

  def self.down
		add_column :rooms, :godz, :string
		add_column :rooms, :dni, :string
  end
end
