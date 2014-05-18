module Pyrite
  class BlocksGroup < ActiveRecord::Base
    belongs_to :group
    belongs_to :block
  end
end
