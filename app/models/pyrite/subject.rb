module Pyrite
  class Subject < ActiveRecord::Base
    has_many :blocks

    validates :name, :uniqueness => true
    validates :name, :presence => true
  end
end
