lock '3.3.5'

set :application, ENV.fetch('REPO_NAME')
set :repo_url, "git@github.com:#{fetch(:application)}.git"
set :scm, :git
set :deploy_to, "/home/merkushin/builds/#{fetch(:application)}"
set :format, :pretty
set :log_level, :info
set :linked_dirs, []
set :keep_releases, 3
set :branch, ENV['REVISION']
set :ssh_options, {forward_agent: true, user: 'merkushin'}
