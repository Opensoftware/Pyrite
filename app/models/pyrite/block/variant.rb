module Pyrite
  class Block::Variant < ActiveRecord::Base
    has_many :blocks, :dependent => :destroy

    validates :name, :short_name, :color, :presence => true

    def color_number
      color[1..-1]
    end
  end
end
