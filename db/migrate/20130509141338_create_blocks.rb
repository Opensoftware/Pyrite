class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :lecturer_id
      t.integer :event_id #academic_years_event
      t.integer :meeting_id #academic_years_meeting
      t.integer :room_id
      t.integer :type_id
      t.boolean :reservation, :default => false
      t.string :name
      t.text :comments
      t.timestamps
    end
  end
end
