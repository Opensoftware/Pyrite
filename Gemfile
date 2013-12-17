source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'devise'
gem 'pdfkit'
gem "cancan"
gem 'airbrake'
gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-ui-rails'
  gem "twitter-bootstrap-rails"
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails"
end

gem 'jquery-rails'

group :development do
  gem 'hirb'
  gem 'sqlite3'
  gem "better_errors"
  gem "binding_of_caller"
  gem "capistrano", github: 'capistrano/capistrano', branch: 'master'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'capistrano-rails', '~> 1.1.0'
  gem "thin"
end

group :production do
  gem "pg"
end
