require 'simple-navigation'
module Pyrite
  class Engine < ::Rails::Engine
    isolate_namespace Pyrite
    path = File.join(Pyrite::Engine.root, "app", "navigations", "pyrite")
    SimpleNavigation.config_file_paths << path

    initializer "pyrite.assets.precompile" do |app|
      app.config.assets.precompile += ["pyrite/OpenLayers.js", "pyrite/spectrum.js", "pyrite/blocks.js",
                                                     "pyrite/blocks/new.js", "pyrite/timetable_forms.js",
                                   "pyrite/buildings.js", "pyrite/buildings/edit.js",
                                   "pyrite/buildings/show.js", "pyrite/blocks/new_part_time.js",
                                   "pyrite/block/types.js", "pyrite/academic_years.js",
                                   "pyrite/settings.js", "pyrite/reservations.js",
                                   "pyrite/buildings.css", "pyrite/blocks.css",
                                   "pyrite/block/types.css", "pyrite/spectrum.css", "pyrite/theme/default/style.css",
                                   "pyrite/theme/default/img/*", "pyrite/theme/default/google.css",
                                   "pyrite/theme/default/style.mobile.css", "pyrite/theme/default/ie6-style.css",
                                   "pyrite/chosen-sprite.png"
      ]
    end
  end
end
