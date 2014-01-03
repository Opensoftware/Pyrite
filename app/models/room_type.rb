class RoomType < ActiveRecord::Base
  attr_accessible :name, :short_name, :description

  validates :name, :short_name, presence: true
  has_many :room, :dependent => :destroy
end
