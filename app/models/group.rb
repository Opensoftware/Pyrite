class Group < ActiveRecord::Base
  has_many :blocks, :through => :blocks_groups
  has_many :blocks_groups, :dependent => :destroy

  attr_accessible :name

end
