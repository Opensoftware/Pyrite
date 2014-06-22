module Pyrite
  class BlocksRoom < ActiveRecord::Base
    belongs_to :room
    belongs_to :block
  end
end
