# Set a default host that will be used in all mailers
unless ENV['ASSETS_PRECOMPILE']
  Rails.application.config.action_mailer.default_url_options = {host: ENV.fetch('SHIPLIX_HOST')}
end
