module Pyrite
  class Lecturer < ActiveRecord::Base
    has_many :blocks, :dependent => :destroy

    validates :full_name, :presence => true

    def name_with_title
      "#{title} #{full_name}"
    end
  end
end
