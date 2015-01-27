require 'rails_helper'

describe Analyzers::BrakemanService do
  let(:build) { create :push }
  let(:path_to_repo) { path_to_repo_files('brakeman') }

  before do
    stub_build(build, path_to_repo.to_s)
  end

  subject(:service) { described_class.new(build) }

  it do
    service.call
  end
end
