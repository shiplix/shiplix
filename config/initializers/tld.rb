HOST = ENV.fetch('SHIPLIX_HOST')
Rails.application.config.action_dispatch.tld_length = HOST.split('.').size.pred
