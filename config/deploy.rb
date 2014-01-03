set :application, 'Siatka2.0-Demo'
set :repo_url, "ssh://gerrit.opensoftware.pl:13523/siatka"
set :user, "rails"
set :branch, "siatka2.0"
set :deploy_via, :remote_cache
set :format, :pretty
set :log_level, :debug
set :pty, true
set :use_sudo, false
set :deploy_to, "/var/www/rails_app/siatka-demo"
set :scm, :git
set :rails_env, "test"

# RVM

set :rvm_type, :user
set :rvm_ruby_version, '2.0.0@siatka2.0'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# Bundler

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment'
set :bundle_without, "development"
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all
set :keep_releases, 3
set :linked_dirs, %w{tmp/pids}
set :linked_files, %w{config/database.yml config/initializers/secret_token.rb config/unicorn/test.rb config/initializers/errbit.rb}


namespace :siatka do
  task :setup_configs do
    on roles(:all) do
      shared_configs = File.join(shared_path,'config')

      # Generate unique secret token
      if test("[ ! -f #{shared_configs}/initializers/secret_token.rb ]")
        execute %Q[ cd #{release_path}
        echo "SiatkaGit::Application.config.secret_token = '$(bundle exec rake secret)'" > #{shared_configs}/initializers/secret_token.rb]
      end
    end
  end

end

before 'deploy:compile_assets', 'siatka:setup_configs'

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, :exec, "unicorn -E #{fetch(:rails_env)} -c config/unicorn/#{fetch(:rails_env)}.rb -D"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        if test("[ -f tmp/pids/unicorn/pid ]")
          execute :kill, '-s USR2 `cat "tmp/pids/unicorn.pid"`'
        else
          puts "Sorry can not restart, server is not runing"
        end
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :kill, '-s QUIT `cat "tmp/pids/unicorn.pid"`'
      end
    end
  end

  desc 'Errbit notification about deploy'
  task :notify_errbit do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          airbrake_opts = "TO=#{fetch(:rails_env)} "
          airbrake_opts += "REVISION=#{fetch(:branch)} "
          airbrake_opts += "REPO=#{fetch(:repo_url)}"
          execute :bundle, :exec, :rake, 'airbrake:deploy', airbrake_opts
        end
      end
    end
  end

  after :publishing, :restart
  after :publishing, :notify_errbit

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
