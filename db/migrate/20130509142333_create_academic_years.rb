class CreateAcademicYears < ActiveRecord::Migration
  def change
    create_table :pyrite_academic_years do |t|
      t.date :start_date
      t.date :end_date
      t.string  :name
      t.timestamps
    end
  end
end
