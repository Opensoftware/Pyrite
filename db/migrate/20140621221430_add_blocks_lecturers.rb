class AddBlocksLecturers < ActiveRecord::Migration
  def change
    create_table :pyrite_blocks_lecturers, :force => true do |t|
      t.integer :lecturer_id, :block_id
    end
  end
end
