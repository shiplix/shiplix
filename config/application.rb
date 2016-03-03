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
      #{config.root}/app/jobs/concerns
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
    config.action_mailer.default_url_options = {host: ENV.fetch('SHIPLIX_HOST', "shiplix.local")}

    # JSON
    require 'multi_json'
    MultiJson.use :oj

    # cache
    cache_namespace = ENV.fetch('SHIPLIX_REDIS_CACHE_NAMESPACE', "shiplix").dup
    if File.exists?(Rails.root.join('REVISION'))
      rev = File.read(Rails.root.join('REVISION')).strip[0..3]
      cache_namespace << "_#{rev}" if rev.present?
    end

    config.cache_store = :readthis_store, {
      expires_in: 1.day.to_i,
      namespace: cache_namespace,
      redis: {
        host: ENV.fetch('SHIPLIX_REDIS_HOST', "localhost"),
        post: ENV.fetch('SHIPLIX_REDIS_PORT', 6379),
        db: ENV.fetch('SHIPLIX_REDIS_CACHE_DB', 0),
        driver: :hiredis
      }
    }

    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
      g.test_framework :rspec
      g.stylesheets false
      g.javascripts false
    end
  end
end
