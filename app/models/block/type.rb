class Block::Type < ActiveRecord::Base
  has_many :blocks, :dependent => :destroy
  attr_accessible :description, :name, :short_name, :color

  validates :name, :short_name, :color, :presence => true

  def color_number
    color[1..-1]
  end
end
