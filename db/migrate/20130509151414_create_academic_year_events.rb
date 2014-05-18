class CreateAcademicYearEvents < ActiveRecord::Migration
  def change
    create_table :pyrite_academic_year_events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :lecture_free
      t.integer :academic_year_id

      t.timestamps
    end
  end
end
