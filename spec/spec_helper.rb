$: << File.expand_path("../..", __FILE__)
Dir['spec/support/**/*.rb'].each { |f| require f }

require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
  config.include BuildHelper

  config.before(:each) do
    stub_env
  end
end
