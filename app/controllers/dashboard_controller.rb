class DashboardController < ApplicationController
  layout "application"

  def index
    @groups_with_url = Group.all.collect {|group| [group.name, timetable_group_path(group.id)]} || []
    @rooms_with_url = Room.all.collect {|room| [room.name, timetable_room_path(room.id)]} || []
  end
end
