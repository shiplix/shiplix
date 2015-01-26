lock '3.3.5'

set :application, 'shiplix'
set :repo_url, 'git@bitbucket.org:shiplix/shiplix.git'
set :scm, :git
set :deploy_to, '/home/ubuntu/sites/shiplix'
set :format, :pretty
set :log_level, :debug
set :bundle_flags, '--deployment'
set :linked_dirs, %w{log tmp public/system}
set :linked_files, %w{.env config/initializers/overrides.rb}
set :keep_releases, 7
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :rails_env, 'production'
set :ssh_options, {forward_agent: true, user: 'ubuntu'}

# https://github.com/capistrano/bundler/issues/45
set :bundle_binstubs, nil

SSHKit.config.command_map[:rake] = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'

namespace :deploy do
  desc 'Configure environment'
  task :config_env do
    on roles(:app) do
      within release_path do
        with :project => :deploy, :deploy => fetch(:stage) do
          execute release_path.join('bin', 'config_env')
        end
      end
    end
  end

  before :updated, :config_env

  desc 'Restart resque'
  task :restart_resque do
    on roles(:job) do
      within release_path do
        execute :rake, 'resque:restart'
      end
    end
  end

  after :publishing, :restart_resque

  desc 'Slack notice'
  task :slack_notice do
    run_locally do
      deployer = ENV.fetch('DEPLOYER_NAME', 'Anonymous')
      payload = {
        channel: "##{fetch(:slack_channel)}",
        username: 'Samson',
        text: "Deployed Shiplix::#{fetch(:deploy_name)} from #{fetch(:branch)} by #{deployer}",
        icon_emoji: ':rocket:'
      }

      execute :curl, "-X POST --data-urlencode 'payload=#{payload.to_json}' #{fetch(:slack_url)}"
    end
  end

  after :finished, :slack_notice
end
