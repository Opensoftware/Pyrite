module Pyrite
  class Group < ActiveRecord::Base
    has_many :blocks, :through => :blocks_groups
    has_many :blocks_groups, :dependent => :destroy

    validates :name, :presence => true, :uniqueness => { :scope => :part_time }

    scope :for_event, ->(event_id) { where(:event_id => event_id) }
    scope :part_time, -> { where(:part_time => true) }
    scope :full_time, -> { where(:part_time => false) }

    def pdf_title
      I18n.t("pyrite.pdf.label.timetable_for_group", :name => name)
    end

    def is_part_time?
      part_time
    end

  end
end
