class Settings < ActiveRecord::Base

  # Available settings
  attr_accessor :plan_to_view, :plan_to_edit, :email_contact, :unit_name

  attr_accessible :key, :value

  after_update :refresh_cache
  after_create :refresh_cache

  class << self

    # If plan_to_edit is not set, default one is the first found.
    def plan_to_edit
      get_value_for("plan_to_edit") || AcademicYear.first.try(:id)
    end

    def current_plan_name
      Rails.cache.fetch("settings:current_plan_name") do
        AcademicYear.where(:id => plan_to_view).first.try(:name)
      end
    end

    def plan_to_view
      get_value_for("plan_to_view")
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

    def fetch_settings
      settings = Settings.new
      settings.plan_to_view = plan_to_view
      settings.plan_to_edit = plan_to_edit
      settings.email_contact = email_contact
      settings.unit_name = unit_name
      settings
    end
  end


  private

    def refresh_cache
      Rails.cache.write("settings:#{self.key}", self.value)
      if key == "plan_to_view"
        current_name = AcademicYear.where(:id => Settings.plan_to_view).first.try(:name)
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
    end
end
