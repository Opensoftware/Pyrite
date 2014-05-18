module Pyrite
  module MainHelper

    def cache_key_for_rooms_with_url
      count          = Room.count
      max_updated_at = Room.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "rooms/all-#{count}-#{max_updated_at}"
    end

    def cache_key_for_groups_with_url
      count          = Group.count
      max_updated_at = Group.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "groups/all-#{count}-#{max_updated_at}"
    end

    def cache_key_for_timetable_forms
      count          = Group.count
      max_group_updated_at = Group.maximum(:updated_at).try(:utc).try(:to_s, :number)
      count          += Room.count
      max_room_updated_at = Room.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "timetable-forms/all-#{count}-#{max_group_updated_at}-#{max_room_updated_at}"
    end
  end
end
