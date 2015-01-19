ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'fakefs/spec_helpers'


ActiveRecord::Migration.maintain_test_schema!


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include FakeFS::SpecHelpers, fakefs: true

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
