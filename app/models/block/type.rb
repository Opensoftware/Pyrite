class Block::Type < ActiveRecord::Base
  attr_accessible :description, :name, :short_name
end
