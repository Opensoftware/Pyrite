class Block::Date < ActiveRecord::Base
  self.skip_time_zone_conversion_for_attributes = [:start_date, :end_date]
  belongs_to :block
end
