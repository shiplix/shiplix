ASSETS_SCHEMA = ENV.fetch('SHIPLIX_ASSETS_SCHEMA', 'http://')
ASSETS_HOST = ENV.fetch('SHIPLIX_ASSETS_HOST', ENV.fetch('SHIPLIX_HOST'))
ASSETS_PORT = ENV['SHIPLIX_ASSETS_PORT']
ASSETS_URL = "#{ASSETS_SCHEMA}#{ASSETS_HOST}#{":#{ASSETS_PORT}" if ASSETS_PORT}"

Rails.application.config.action_controller.asset_host = ASSETS_URL

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
#Rails.application.config.assets.precompile += %w()
