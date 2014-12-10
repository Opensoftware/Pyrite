require 'simple-navigation'
module Pyrite
  class Engine < ::Rails::Engine
    isolate_namespace Pyrite
    path = File.join(Pyrite::Engine.root, "app", "navigations", "pyrite")
    SimpleNavigation.config_file_paths << path

    config.to_prepare do
      Dir.glob(Pyrite::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "pyrite.assets.precompile" do |app|
      app.config.assets.precompile += ["pyrite/spectrum.js", "pyrite/blocks.js",
                                   "pyrite/blocks/new.js", "pyrite/timetable_forms.js",
                                   "pyrite/blocks/new_part_time.js",
                                   "pyrite/block/types.js", "pyrite/academic_years.js",
                                   "pyrite/settings.js", "pyrite/reservations.js",
                                   "pyrite/buildings.css", "pyrite/blocks.css",
                                   "pyrite/block/types.css", "pyrite/spectrum.css",
                                   "pyrite/chosen-sprite.png", "fonts/*", "pyrite/select2.png"
      ]
    end
  end
end
