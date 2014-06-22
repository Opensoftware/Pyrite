class AddBlocksRooms < ActiveRecord::Migration
  def change
    create_table :pyrite_blocks_rooms, :force => true do |t|
      t.integer :room_id, :block_id
    end
  end
end
