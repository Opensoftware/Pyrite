module Pyrite
  class Lecturer < ::Employee
    has_many :blocks, :dependent => :destroy

  end
end
