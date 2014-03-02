class Room < ActiveRecord::Base
  attr_accessible :name, :type, :capacity, :building_id, :comments, :room_type_id

  belongs_to :building
  belongs_to :room_type
  has_many :blocks, :dependent => :destroy


  def type
    room_type.short_name
  end

  def name_with_building
    "#{name}, #{building.name}"
  end
end
