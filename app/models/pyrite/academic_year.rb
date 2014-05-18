module Pyrite
  class AcademicYear < ActiveRecord::Base
    has_many :events, :dependent => :destroy

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

    def is_for_viewing?
      for_viewing = AcademicYear.for_viewing
      if for_viewing == self
        return true
      else
        return false
      end
    end

    def is_for_editing?
      for_editing = AcademicYear.for_editing
      if for_editing == self
        return true
      else
        return false
      end
    end

    def is_used_in_settings?
      is_for_viewing? || is_for_editing?
    end
  end
end
