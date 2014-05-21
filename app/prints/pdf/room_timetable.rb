class Pdf::RoomTimetable < Pdf::Timetable

  def initialize(rooms, event_id, available_days)
    @collection = rooms
    @event_id = event_id
    @available_days = available_days
    super({})
  end

  private

    def draw_blocks(blocks)
      blocks.each do |block|
        timetable_content_height = bounds.top - @title_row_size
        block_start_hour = block.dates.first.start_date.seconds_since_midnight/60
        block_end_hour = block.dates.first.end_date.seconds_since_midnight/60
        block_length = (block_end_hour - block_start_hour )/ 15 * @minute_row
        block_start_distance = block_start_hour - @start_hour.seconds_since_midnight/60
        next if block_start_distance < 0
        block_start_point = @timetable_content_height - @minute_row * block_start_distance/15
        bounding_box [column_position(block), block_start_point], :width => @column_size, :height => block_length do
          fill_color block.variant.color_number
          fill_rectangle [bounds.left, bounds.top], @column_size, block_length
          fill_color "#000000"
          stroke_bounds
          font_size 9
          text_box block.name, :at => [0, bounds.top - 25], :align => :center
          font_size 7
          start_hour = block.dates.first.start_date.strftime("%H:%M")
          end_hour = block.dates.first.end_date.strftime("%H:%M")
          font_size 5
          text_box "#{start_hour} - #{end_hour}", :at => [0, bounds.top - 3], :align => :center
          text_box "#{block.variant.name}", :at => [5, bounds.top - 20 ], :align => :center
          text_box block.lecturer_name, :at => [0, bounds.top - 10], :align => :center
          font_size 4
          text_box "#{block.groups_names}", :at => [5, bounds.bottom + 5], :align => :center
        end
      end
    end

end
