class Freeday < ActiveRecord::Base
  attr_accessible :nazwa, :start, :stop
  validates_presence_of     :start, :nazwa, :stop
end
