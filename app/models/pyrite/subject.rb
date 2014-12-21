module Pyrite
  class Subject < ActiveRecord::Base
    has_many :blocks
  end
end
