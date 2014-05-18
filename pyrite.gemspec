$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pyrite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pyrite"
  s.version     = Pyrite::VERSION
  s.authors     = ["opensoftwre.pl"]
  s.email       = ["contact@opensoftware.pl"]
  s.homepage    = "mine.opensoftware.pl"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.4"
  # TODO add usi/core as dependency

end
