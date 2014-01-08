module BlocksHelper
  def convert_blocks_to_events(blocks)
    blocks.reduce([]) do |sum, block|
      block.dates.each do |date|
        sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date, allDay: false}
      end
      sum
    end
  end

  def timetable_forms_data
    @groups_with_url = Group.all.collect {|group| [group.name, timetable_group_path(group.id)]}
    @rooms_with_url = Room.all.collect {|room| [room.name, timetable_room_path(room.id)]}
    @rooms_reservations_with_url = Room.all.collect {|room| [room.name, show_reservations_path(room.id)]} || []
  end
end
