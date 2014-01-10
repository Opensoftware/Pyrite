class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :title
      t.string :full_name

      t.timestamps
    end
  end
end
