class AcademicYear::Meeting < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :name
  belongs_to :event
  has_many :blocks, :dependent => :destroy

  validates :start_date, :end_date, :name, :presence => true


  def self.for_editing
    AcademicYear::Meeting
      .where(:event_id => Settings.event_id_for_editing)
      .order(:start_date)
  end
end
