class Block::Variant < ActiveRecord::Base
  has_many :blocks, :dependent => :destroy, :foreign_key => "type_id"

  # TODO after replacing AR by DM rename model and move back to block_types by
  # default
  self.table_name = "block_types"

  validates :name, :short_name, :color, :presence => true

  def color_number
    color[1..-1]
  end
end
