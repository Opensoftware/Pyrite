class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :building
  belongs_to :event
  belongs_to :block_type

  has_and_belongs_to_many :groups

  attr_accessible :name, :start, :end, :comments, :group_ids, :lecturer_id, :room_id, :event_id, :block_type_id

end
