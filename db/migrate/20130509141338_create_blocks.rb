class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :lecturer_id
      t.integer :event_id #academic_years_event
      t.integer :room_id
      t.integer :building_id
      t.integer :block_type_id
      t.boolean :reservation, :default => false
      t.string :name
      t.text :comments
      t.timestamps
    end
  end
end
