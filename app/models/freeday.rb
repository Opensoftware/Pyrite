class Freeday < ActiveRecord::Base
  validates_presence_of     :start, :nazwa, :stop
end
