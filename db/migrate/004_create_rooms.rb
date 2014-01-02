class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :capacity
      t.integer :room_type_id
      t.integer :building_id
      t.text :comments

      t.timestamps
    end
  end

end
