class CreateBlocksGroups < ActiveRecord::Migration
  def change
    create_table :pyrite_blocks_groups, :force => true do |t|
      t.integer :group_id, :block_id
    end
  end
end
