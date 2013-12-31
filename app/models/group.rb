class Group < ActiveRecord::Base
  # TODO remove those relations as it was replaced with blocks
  # has_and_belongs_to_many :plans
  # has_and_belongs_to_many :reservations
  has_many :blocks, :through => :blocks_groups
  has_many :blocks_groups, :dependent => :destroy

  attr_accessible :name

end
