class AcademicYear::Event < ActiveRecord::Base
  attr_accessible :end_date, :lecture_free, :name, :start_date
  belongs_to :academic_year
  has_many :blocks


  scope :current_for_edit, where(:academic_year_id => Settings.plan_to_edit)
  scope :currnet_for_view, where(:academic_year_id => Settings.plan_to_view)
end
