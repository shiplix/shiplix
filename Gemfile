source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'
gem 'rails-i18n'
gem 'dotenv-rails'

# Data
gem 'pg'
gem 'pg_array_parser'
gem 'postgresql_cursor'
gem 'foreigner'
gem 'seedbank'
gem 'multi_json'
gem 'oj'
gem 'redis'
gem 'hiredis'
gem 'dalli'
gem 'rails-cache-tags'
gem 'redis-mutex'
gem 'octokit'

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

# Assets
gem 'font-awesome-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-highlightjs'
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

# Back
gem 'resque', '~> 1.25'
gem 'resque-retry'
gem 'resque-god'
gem 'resque-single'
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
  gem 'capistrano3-puma'
  gem 'quiet_assets'
  gem 'wirble'
  gem 'awesome_print'
end

group :production, :development do
  gem 'puma'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'timecop'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'rspec-rails'
  gem 'rspec-given'
  gem 'test_after_commit'
  gem 'mock_redis', :github => 'causes/mock_redis' # необходимо пояснения, почему так?
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
