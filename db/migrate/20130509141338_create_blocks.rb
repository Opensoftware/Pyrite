class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :pyrite_blocks do |t|
      t.integer :event_id #academic_years_event
      t.integer :meeting_id #academic_years_meeting
      t.integer :variant_id
      t.boolean :reservation, :default => false
      t.string :name
      t.text :comments
      t.timestamps
    end
  end
end
