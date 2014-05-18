module Pyrite
  class Block::Date < ActiveRecord::Base
    belongs_to :block
  end
end
