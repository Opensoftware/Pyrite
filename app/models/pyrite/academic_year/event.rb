module Pyrite
  class AcademicYear::Event < ActiveRecord::Base
    belongs_to :academic_year
    has_many :blocks, :dependent => :destroy
    has_many :meetings, :dependent => :destroy

    validates :start_date, :end_date, :name, :presence => true

    scope :for_academic_year, ->(id) { where(:academic_year_id => id)}


    def self.for_viewing
      find(Settings.event_id_for_viewing)
    end

    def self.for_editing
      find(Settings.event_id_for_editing)
    end

    def is_for_viewing?
      for_viewing = AcademicYear::Event.for_viewing
      for_viewing == self
    end

    def is_for_editing?
      for_editing = AcademicYear::Event.for_editing
      for_editing == self
    end

  end
end