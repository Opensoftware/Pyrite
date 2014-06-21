module Pyrite
  class Lecturer < ::Employee
    has_many :blocks_lecturers
    has_many :blocks, :through => :blocks_lecturers, :dependent => :destroy

  end
end
