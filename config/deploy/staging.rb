server '54.149.182.233', roles: [:web, :app, :db, :job]

set :deploy_name, 'Staging'
set :slack_channel, 'general'
set :slack_url, 'https://hooks.slack.com/services/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'
