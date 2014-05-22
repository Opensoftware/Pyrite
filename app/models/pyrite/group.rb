module Pyrite
  class Group < ActiveRecord::Base
    has_many :blocks, :through => :blocks_groups
    has_many :blocks_groups, :dependent => :destroy

    validates :name, :presence => true, :uniqueness => true

    scope :for_event, ->(event_id) { where(:event_id => event_id) }

    def pdf_title
      I18n.t("pyrite.pdf.label.timetable_for_group", :name => name)
    end

  end
end
