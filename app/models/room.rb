class Room < ActiveRecord::Base
  attr_accessible :name, :type, :capacity, :building_id, :comments

  belongs_to :building
  has_many :blocks, :dependent => :destroy
end
