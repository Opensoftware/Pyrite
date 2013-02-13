class ChangeTypeRoomReservation < ActiveRecord::Migration
  def self.up
			change_column :reservations, :sala, :string
  end

  def self.down
			change_column :reservations, :sala, :integer
  end
end
