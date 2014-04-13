require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  #Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

module Pyrite
  class Application < Rails::Application
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :pl
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '2.0'

    config.time_zone = 'Warsaw'
    config.active_record.default_timezone = :utc

    # precompile assets which are not part of any manifest but are used in
    # different views
    config.assets.precompile += ["OpenLayers.js", "spectrum.js", "blocks.js",
                                 "blocks/new.js", "timetable_forms.js",
                                 "buildings.js", "buildings/edit.js",
                                 "buildings/show.js", "blocks/new_part_time.js",
                                 "block/types.js", "academic_years.js",
                                 "settings.js", "reservations.js",
                                 "buildings.css", "blocks.css",
                                 "block/types.css", "spectrum.css", "theme/default/style.css",
                                 "theme/default/img/*", "theme/default/google.css",
                                 "theme/default/style.mobile.css", "theme/default/ie6-style.css"]
  end
end
