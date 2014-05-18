module Pyrite
  class RoomType < ActiveRecord::Base
    validates :name, :short_name, presence: true
    has_many :room, :dependent => :destroy
  end
end
