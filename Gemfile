source 'https://rubygems.org'

gem 'rails', '4.0.4'
gem 'devise'
gem 'prawn'
gem "cancan"
gem 'airbrake'
gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails"
  gem "non-stupid-digest-assets"
end

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
  gem 'sprockets_better_errors'
end

group :production do
  gem "pg"
end
