class AcademicYear::Event < ActiveRecord::Base
  attr_accessible :end_date, :lecture_free, :name, :start_date
  belongs_to :academic_year
  has_many :blocks
end
