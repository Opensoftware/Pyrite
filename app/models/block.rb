class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :building
  belongs_to :event
  belongs_to :block_type

  has_many :groups

  attr_accessible :name, :start, :end, :comments

end
