lock '3.4.0'

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
set :tg_token, '153189057:AAHXw4ZBqd7Q-CFoGrl3DSD9bOGJIWFtyjc'
set :tg_chat_id, -18419020

# https://github.com/capistrano/bundler/issues/45
set :bundle_binstubs, nil

SSHKit.config.command_map[:rake] = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
    invoke 'resque:restart'
  end

  after :publishing, :restart

  desc 'TG notice'
  task :tg_notice do
    # get chat id https://api.telegram.org/bot{TOKEN}/getUpdates?offset=0
    Telegram::Bot::Client.run(fetch(:tg_token)) do |bot|
      bot.api.send_message(
        chat_id: fetch(:tg_chat_id),
        text: "Deployed Shiplix::#{fetch(:deploy_name)} from #{fetch(:branch)}"
      )
    end
  end

  after :finished, :tg_notice
end

namespace :resque do
  task :restart do
    on roles(:job) do
      within release_path do
        execute :rake, 'resque:restart'
      end
    end
  end
end
