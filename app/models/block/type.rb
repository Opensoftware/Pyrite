class Block::Type < ActiveRecord::Base
  has_many :blocks, :dependent => :destroy
  attr_accessible :description, :name, :short_name, :color
end
