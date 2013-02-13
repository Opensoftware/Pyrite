class CreateLecturers < ActiveRecord::Migration
  def self.up
    create_table :lecturers do |t|
      t.column "title", :string
      t.column "lecture", :string
      t.timestamps
    end
  end

  def self.down
    drop_table :lecturers
  end
end
