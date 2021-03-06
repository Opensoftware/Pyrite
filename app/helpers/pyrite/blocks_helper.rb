module Pyrite
  module BlocksHelper
    def convert_blocks_to_events(blocks)
      blocks.reduce([]) do |sum, block|
        block.dates.each do |date|
          sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date,
                   allDay: false, backgroundColor: block.variant.try(:color),
                   room_name: block.rooms_names, block_type: block.variant_name,
                   group_names: block.group_names, lecturer: block.lecturer_name,
                   url: edit_block_path(block), delete_url: block_path(block),
                   move_url: move_block_path(block), resize_url: resize_block_path(block),
                   comments: block.comments
          }
        end
        sum
      end
    end

    def convert_blocks_to_events_for_viewing(blocks)
      blocks.reduce([]) do |sum, block|
        block.dates.each do |date|
          sum << { id: block.id, title: block.name, start: date.start_date, end: date.end_date,
                   allDay: false, backgroundColor: block.variant.try(:color),
                   room_name: block.rooms_names, block_type: block.variant_name,
                   group_names: block.group_names, lecturer: block.lecturer_name,
                   comments: block.comments
          }
        end
        sum
      end
    end

    def timetable_forms_data
      @groups_with_url = Group.all.collect {|group|
        [group.name, pyrite.group_timetable_path(group.id)]
      }
      @rooms_with_url = Room.all.collect {|room|
        [room.name_with_building, pyrite.room_timetable_path(room.id)]
      }
      @rooms_reservations_with_url = Room.all.collect {|room|
        [room.name_with_building, pyrite.show_reservations_path(room.id)]
      }
      @lecturers_with_url = Lecturer.all.collect { |lecturer|
        [lecturer.full_name, pyrite.lecturer_timetable_path(lecturer.id)]
      }
    end

    def print_forms_data
      events = AcademicYear.for_viewing.events
      @events_with_url_for_groups = events.collect {|event|
        [event.name, print_all_groups_timetable_path(event.id)]
      }
      @events_with_url_for_rooms = events.collect {|event|
        [event.name, print_all_rooms_timetable_path(event.id)]
      }
      @events_with_url_for_lecturers= events.collect {|event|
        [event.name, print_all_lecturers_timetable_path(event.id)]
      }
    end

    def color_box(hex)
      html = "<div class='colorbox' style='background-color:#{hex}'></div>"
    end

    def days_for_select
      swap_monday(available_abbr_days_for_select)
    end

    def days_select_options(days)
      options = []
      days.each { |date|
        options << [I18n.l(date, :format => :day_name), date.strftime("%F")]
      }
      return options
    end
  end
end
