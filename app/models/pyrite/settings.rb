module Pyrite
  class Settings < ActiveRecord::Base
    # TODO this should inherite from Usi::Settings but there is no namespaces in
    # Usi so we have to point it to proper table for know.

    def self.table_name
      "settings"
    end

    # Available settings
    attr_accessor :event_id_for_viewing, :event_id_for_editing, :email_contact, :unit_name,
                  :pdf_subtitle

    after_update :refresh_cache
    after_create :refresh_cache

    class << self

      def event_id_for_editing
        get_value_for("event_id_for_editing") || AcademicYear::Event.first.try(:id)
      end

      def event_id_for_viewing
        get_value_for("event_id_for_viewing") || AcademicYear::Event.first.try(:id)
      end

      def current_plan_name
        Rails.cache.fetch("settings:current_plan_name") do
          AcademicYear::Event.for_viewing.try(:name)
        end
      end

      def email_contact
        get_value_for("email_contact")
      end

      def unit_name
        get_value_for("unit_name")
      end

      def update_settings(settings = {})
        transaction do
          settings.each do |key, value|
            setting = Settings.where(:key => key).first
            if setting
              setting.value = value
              setting.save
            else
              Settings.create(:key => key, :value => value)
            end
          end
        end
      end

      def pdf_subtitle
        get_value_for("pdf_subtitle")
      end

      def fetch_settings
        settings = Settings.new
        settings.event_id_for_viewing = event_id_for_viewing
        settings.event_id_for_editing = event_id_for_editing
        settings.email_contact = email_contact
        settings.unit_name = unit_name
        settings.pdf_subtitle = pdf_subtitle
        settings
      end

      def reset_event_id_for_editing
        remove_setting("event_id_for_editing")
      end

      def reset_event_id_for_viewing
        remove_setting("event_id_for_viewing")
      end

    end


    private

      def refresh_cache
        Rails.cache.write("settings:#{key}", value)
        if key == "event_id_for_viewing"
          current_name = AcademicYear::Event.for_viewing.try(:name)
          Rails.cache.write("settings:current_plan_name", current_name)
        end
      end

      class << self
        def get_value_for(key)
          cache_key = "settings:#{key}"
          obj = Rails.cache.fetch(cache_key) {
            Settings.where(:key => key).first.try(:value)
          }
        end

        def remove_setting(key)
          setting = Settings.where(:key => key).first
          if setting
            setting.destroy
            Rails.cache.delete("settings:#{key}")
          end
        end
      end
  end
end
