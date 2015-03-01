module Pyrite
  class Lecturer < ::Employee
    has_many :blocks_lecturers
    has_many :blocks, :through => :blocks_lecturers, :dependent => :destroy

    def pdf_title
      I18n.t("pyrite.pdf.label.timetable_for_lecturer", :name => full_name)
    end
  end
end
