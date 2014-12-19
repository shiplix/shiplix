server '', roles: [:web, :app, :db, :job]

set :deploy_name, 'Staging'
set :slack_channel, 'deploy'
set :slack_domain, 'shiplix'
set :slack_token, ''
