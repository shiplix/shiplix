server 'ec2-54-148-161-96.us-west-2.compute.amazonaws.com', roles: [:web, :app, :db, :job]

set :deploy_name, 'Staging'
set :slack_channel, 'deploy'
set :slack_domain, 'shiplix'
set :slack_token, ''
