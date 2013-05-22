class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.datetime :start
      t.datetime :end
      t.integer :lecturer_id
      t.integer :event_id #academic_years_event
      t.integer :room_id
      t.integer :building_id
      t.integer :block_type_id
      t.string :name
      t.text :comments
      t.timestamps
    end
  end
end
