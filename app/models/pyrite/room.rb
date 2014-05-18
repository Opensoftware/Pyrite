module Pyrite
  class Room < ActiveRecord::Base
    validates :name, :building_id, :room_type_id, :presence => true

    belongs_to :building
    belongs_to :room_type
    has_many :blocks, :dependent => :destroy

    def type
      room_type.short_name
    end

    def name_with_building
      "#{name}, #{building.name}"
    end

    def pdf_title
      I18n.t("pyrite.pdf.label.timetable_for_room", :name => name)
    end
  end
end
