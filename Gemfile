source 'https://rubygems.org'

gemspec

gem 'airbrake'
gem 'unicorn'

# TODO remove that since this is anyway part of the core and is not loaded from
# gemfile. All should be in gemspec
gem 'therubyracer', :platforms => :ruby
gem 'uglifier'
gem "less-rails"
gem "non-stupid-digest-assets"
gem "sass-rails"
gem "bootstrap-sass"
gem 'simple-navigation'
gem 'simple-navigation-bootstrap'

group :development do
  gem 'hirb'
  gem 'wirble'
  gem 'interactive_editor'
  gem "better_errors"
  gem "binding_of_caller"
  gem "capistrano", github: 'capistrano/capistrano', branch: 'master'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem "thin"
  gem "byebug"
  gem 'spring'
end

group :production do
  gem "pg"
end
