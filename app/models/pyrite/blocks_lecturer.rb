module Pyrite
  class BlocksLecturer < ActiveRecord::Base
    belongs_to :lecturer
    belongs_to :block
  end
end
