module Pyrite
  class Building < ActiveRecord::Base
    has_many :rooms, :dependent => :destroy

    validates :name, :address, :presence => true

  end
end
