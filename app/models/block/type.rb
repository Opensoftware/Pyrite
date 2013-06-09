class Block::Type < ActiveRecord::Base
  attr_accessible :comment, :name, :short_name
end
