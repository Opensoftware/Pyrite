require 'simple-navigation'
module Pyrite
  class Engine < ::Rails::Engine
    isolate_namespace Pyrite
    path = File.join(Pyrite::Engine.root, "app", "navigations", "pyrite")
    SimpleNavigation.config_file_paths << path
  end
end
