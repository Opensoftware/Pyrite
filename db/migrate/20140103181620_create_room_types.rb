class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.string :name, :null => false
      t.string :short_name, :null => false
      t.string :description

      t.timestamps
    end
  end
end
