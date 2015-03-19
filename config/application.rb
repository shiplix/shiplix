require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shiplix
  class Application < Rails::Application
    Dotenv::Railtie.load unless Rails.env.production?

    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/services/concerns
    )

    config.active_record.schema_format = :sql

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :ru]
    config.i18n.default_locale = :en
    config.i18n.locale = :en

    # Time zone
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc

    # Set a default host that will be used in all mailers
    config.action_mailer.default_url_options = {host: ENV.fetch('SHIPLIX_HOST')}

    # JSON
    require 'multi_json'
    MultiJson.use :oj

    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
      g.test_framework :rspec
      g.stylesheets false
      g.javascripts false
    end
  end
end
