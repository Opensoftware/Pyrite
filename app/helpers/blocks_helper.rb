module BlocksHelper
  def convert_blocks_to_events(blocks)
    blocks.reduce([]) do |sum, block|
      block.dates.each do |date|
        sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date,
                 allDay: false, backgroundColor: block.type.try(:color),
                 room_name: block.room.name_with_building, block_type: block.type_name,
                 groups_names: block.groups_names, lecturer: block.lecturer_name,
                 url: edit_block_path(block), delete_url: block_path(block)
        }
      end
      sum
    end
  end

  def convert_blocks_to_events_for_viewing(blocks)
    blocks.reduce([]) do |sum, block|
      block.dates.each do |date|
        sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date,
                 allDay: false, backgroundColor: block.type.try(:color),
                 room_name: block.room.name_with_building, block_type: block.type_name,
                 groups_names: block.groups_names, lecturer: block.lecturer_name
        }
      end
      sum
    end
  end

  def timetable_forms_data
    @groups_with_url = Group.all.collect {|group|
      [group.name, group_timetable_path(group.id)]
    }
    @rooms_with_url = Room.all.collect {|room|
      [room.name_with_building, room_timetable_path(room.id)]
    }
    @rooms_reservations_with_url = Room.all.collect {|room|
      [room.name_with_building, show_reservations_path(room.id)]
    }
    @lecturers_with_url = Lecturer.all.collect { |lecturer|
      [lecturer.name_with_title, lecturer_timetable_path(lecturer.id)]
    }
  end

  def print_forms_data
    @events_with_url = AcademicYear.for_viewing.events.collect {|event|
      [event.name, print_all_groups_timetable_path(event.id)]
    }
  end

  def color_box(hex)
    html = "<div class='colorbox' style='background-color:#{hex}'></div>"
  end

  def days_for_select
    # Day of the week in 0-6. Sunday is 0; Saturday is 6.
    # Monday should be always first! Monday = 1
    if current_user.preferences[:without_weekends]
      available_abbr_days.zip(0..7).slice(0..4)
    else
      available_abbr_days.zip(0..7)
    end
  end

end
