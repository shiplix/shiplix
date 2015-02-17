require 'rails_helper'

describe PushBuildService do
  let(:repo) { create :repo, full_github_name: 'push_build' }
  let(:branch) { create :branch, repo: repo }
  let(:service) { described_class.new(branch, 'revision') }
  let(:build) { service.build }

  before do
    stub_env
    expect_any_instance_of(ScmUpdateService).to receive(:call)
    service.call
  end

  Then { expect(build.finished?).to be true }
  And { expect(build.smells_count).to eq 2 }
  And { expect(build.klasses.find_by(name: 'DirtyModule::Dirty').smells_count).to eq 2 }
end
