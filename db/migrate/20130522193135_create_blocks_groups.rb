class CreateBlocksGroups < ActiveRecord::Migration
  def change
    create_table :blocks_groups, :id => false, :force => true do |t|
      t.integer :group_id, :block_id
    end
  end
end
