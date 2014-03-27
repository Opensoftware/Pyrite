class AcademicYear < ActiveRecord::Base
  has_many :events

  validates :name, :start_date, :end_date, :presence => true

  class << self
    def for_viewing
      AcademicYear.joins(:events).where("academic_year_events.id = ?",
                                        Settings.event_id_for_viewing).first
    end

    def for_editing
      AcademicYear.joins(:events).where("academic_year_events.id = ?",
                                        Settings.event_id_for_editing).first
    end
  end
end
