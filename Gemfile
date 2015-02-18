source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '4.1.8'
gem 'rails-i18n'
gem 'dotenv-rails'
gem 'pg'
gem 'pg_array_parser'

gem 'sass-rails', '~> 4.0.3'
gem 'less-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'autoprefixer-rails'
gem 'will_paginate-bootstrap'

gem 'draper'
gem 'bootstrap_form'
gem 'vicar', '~> 0.0.2'
gem 'foreigner', '~> 1.6'
gem 'seedbank'
gem 'multi_json'
gem 'oj'
gem 'aasm', '~> 4.0'
gem 'pundit', '~> 0.3'
gem 'redis', '~> 3.1'
gem 'hiredis', '~> 0.5'
gem 'dalli', '~> 2.7'
gem 'rails-cache-tags', '~> 1.3'
gem 'redis-mutex', '~> 3.0'
gem 'omniauth-github'
gem 'attr_extras'
gem 'resque', '~> 1.25'
gem 'resque-retry'
gem 'resque-god'
gem 'resque-single'
gem 'octokit'
gem 'pluggable_js'
gem 'cocaine', require: false
gem 'breadcrumbs_on_rails', '~> 2.3'

gem 'flog', '~> 4.3'
gem 'flay', '~> 2.6'
gem 'reek', '~> 1.6'
gem 'brakeman', '~> 3.0'

# assets
gem 'rails-assets-bootstrap-sass-official', '= 3.3.1'
gem 'rails-assets-jquery-ui', '= 1.11.2'
gem 'font-awesome-rails'

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
  gem 'timecop', '~> 0.7'
  gem "fakefs", require: 'fakefs/safe'
  gem 'rspec-rails', '~> 3.1'
  gem 'rspec-given', '~> 3.5'
  gem 'test_after_commit', '~> 0.4'
  gem 'mock_redis', :github => 'causes/mock_redis'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'shoulda-matchers', '~> 2.7'
  gem 'simplecov', '~> 0.9', require: false
end
