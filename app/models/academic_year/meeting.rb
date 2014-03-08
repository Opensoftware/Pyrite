class AcademicYear::Meeting < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :name
  belongs_to :event
  has_many :blocks, :dependent => :destroy

  validates :start_date, :end_date, :name, :presence => true
end
