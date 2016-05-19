source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'responders', '~> 2.0'
gem 'rails-i18n'
gem 'dotenv-rails'

# Data
gem 'pg'
gem 'postgresql_cursor'
gem 'seedbank'
gem 'multi_json'
gem 'oj'
gem 'redis'
gem 'hiredis'
gem 'redis-mutex'
gem 'octokit'
gem 'readthis'
gem 'jbuilder'
gem 'newrelic_rpm'

# Front
gem 'sass-rails'
gem 'less-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'jquery-rails'
gem 'autoprefixer-rails'
gem 'bootstrap_form'
gem 'will_paginate-bootstrap'
gem 'gretel'
gem 'pluggable_js'
gem 'handlebars_assets'
gem 'hamlbars'
gem 'high_voltage'
gem 'simple-navigation'

# Assets
gem 'font-awesome-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-highlightjs'
  gem 'rails-assets-jquery-cookie'
end

# Auth
gem 'pundit'
gem 'omniauth-github'

# Libs
gem 'draper'
gem 'vicar'
gem 'aasm'
gem 'attr_extras'
gem 'whenever', require: false
gem 'rails-observers'
gem 'stripe'
gem 'virtus'
gem 'interactor'

# Back
gem 'resque', '~> 1.25'
gem 'resque-retry'
gem 'resque-god'
gem 'resque-single'
gem 'resque-web', require: 'resque_web'
gem 'cocaine', require: false

# Analyzers
gem 'flog', '~> 4.3'
gem 'flay', '~> 2.6'
gem 'reek', '~> 2.0'
gem 'brakeman', '~> 3.0'
gem 'astrolabe'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spring'
  gem 'capistrano', '~> 3.2'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem "telegram-bot-ruby"
  gem 'quiet_assets'
  gem 'wirble'
  gem 'awesome_print'
end

group :production do
  gem "unicorn", ">= 5.0.1"
  gem "unicorn-worker-killer", ">= 0.4.4"
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'timecop'
  gem 'rspec-rails'
  gem 'rspec-given'
  gem 'test_after_commit'
  gem 'mock_redis', :github => 'causes/mock_redis' # необходимо пояснения, почему так?
  gem 'webmock'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
