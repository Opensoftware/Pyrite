class CreateAcademicYearMeetings < ActiveRecord::Migration
  def change
    create_table :academic_year_meetings do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :event_id
      t.timestamps
    end
  end
end
