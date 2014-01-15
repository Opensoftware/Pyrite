module BlocksHelper
  def convert_blocks_to_events(blocks)
    blocks.reduce([]) do |sum, block|
      block.dates.each do |date|
        sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date,
                 allDay: false, backgroundColor: block.type.try(:color),
                 room_name: block.room.name, block_type: block.type_name,
                 groups_names: block.groups_names, lecturer: block.lecturer_name }
      end
      sum
    end
  end

  def timetable_forms_data
    @groups_with_url = Group.all.collect {|group|
      [group.name, timetable_group_path(group.id)]
    }
    @rooms_with_url = Room.all.collect {|room|
      [room.name, timetable_room_path(room.id)]
    }
    @rooms_reservations_with_url = Room.all.collect {|room|
      [room.name, show_reservations_path(room.id)]
    }
    @lecturers_with_url = Lecturer.all.collect { |lecturer|
      [lecturer.name_with_title, timetable_lecturer_path(lecturer.id)]
    }
  end

  def color_box(hex)
    html = "<div class='colorbox' style='background-color:#{hex}'></div>"
  end
end
