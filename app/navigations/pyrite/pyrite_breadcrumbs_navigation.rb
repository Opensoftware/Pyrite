SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :home_page, I18n.t("pyrite.breadcrumbs.home_page"), root_path do |home|
      if action_name =~ /timetable/ or controller.controller_name =~ /reservations/
        if @room
          home.item :reservation, I18n.t("pyrite.breadcrumbs.reservation"), show_reservations_path(@room)
          home.item :room, I18n.t("pyrite.breadcrumbs.room"), room_timetable_path(@room)
        end
        if @group
          home.item :group, I18n.t("pyrite.breadcrumbs.group"), group_timetable_path(@group)
        end
        if @lecturer
          home.item :lecturer, I18n.t("pyrite.breadcrumbs.lecturer"), lecturer_timetable_path(@lecturer)
        end
      end
      home.item :dashboard, I18n.t("pyrite.breadcrumbs.dashboard"), dashboard_index_path do |dashboard|
        dashboard.item :reservation, I18n.t("pyrite.breadcrumbs.new_reservation"), new_reservation_path
        dashboard.item :full_time, I18n.t("pyrite.breadcrumbs.full_time.name") do |full_time|
          full_time.item :new_block, I18n.t("pyrite.breadcrumbs.full_time.new_block"), new_block_path
          full_time.item :prints, I18n.t("pyrite.breadcrumbs.full_time.prints"), prints_dashboard_index_path
        end
        dashboard.item :part_time, I18n.t("pyrite.breadcrumbs.part_time.name") do |part_time|
          part_time.item :new_block, I18n.t("pyrite.breadcrumbs.part_time.new_block"), new_part_time_block_path
          part_time.item :prints, I18n.t("pyrite.breadcrumbs.part_time.prints"), prints_part_time_dashboard_index_path
        end

        dashboard.item :settings, I18n.t("pyrite.breadcrumbs.settings"), edit_settings_path
        dashboard.item :user_preferences, I18n.t("pyrite.breadcrumbs.user_preferences"), user_account_path
        dashboard.item :buildings, I18n.t("pyrite.breadcrumbs.buildings.name"), buildings_path  do |building|
          if @building
            if @building.new_record?
              building.item :new, I18n.t("pyrite.breadcrumbs.buildings.new"), new_building_path
            else
              building.item :rooms, I18n.t("pyrite.breadcrumbs.buildings.rooms"), building_path(@building)
              building.item :edit, I18n.t("pyrite.breadcrumbs.buildings.edit"), edit_building_path(@building)
            end
          end
        end
        dashboard.item :block_type, I18n.t("pyrite.breadcrumbs.block.type.name"),  block_types_path do |block_type|
          if @block_type
            if @block_type.new_record?
              block_type.item :new, I18n.t("pyrite.breadcrumbs.block.type.new"), new_block_type_path
            else
              block_type.item :edit, I18n.t("pyrite.breadcrumbs.block.type.edit"), edit_block_type_path(@block_type)
            end
          end
        end
        dashboard.item :groups, I18n.t("pyrite.breadcrumbs.groups.name"), groups_path do |group|
          if @group
            if @group.new_record?
              group.item :new, I18n.t("pyrite.breadcrumbs.groups.new"), new_group_path
            else
              group.item :edit, I18n.t("pyrite.breadcrumbs.groups.edit"), edit_group_path(@group)
            end
          end
        end
      end
    end
  end
end
