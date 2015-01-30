require 'rails_helper'

describe RepoActivatorService do
  let(:repo) { create :repo }
  let(:user) { create :user }
  let(:service) { described_class.new(user, repo) }
  let(:api) { double('Api') }
  let(:hook_id) { 111 }
  let(:deploy_key_id) { 222 }
  let(:recent_revision) { 'commitsha' }

  before do
    create(:membership, user: user, repo: repo)

    allow(api).to receive(:add_hooks).and_yield(hook_id)
    allow(api).to receive(:add_deploy_key).and_yield(deploy_key_id)
    allow(api).to receive(:recent_revision).and_return(recent_revision)
    allow(api).to receive(:default_branch).and_return('master')
    allow(service).to receive(:api).and_return(api)
  end

  context 'when activating repo' do
    before do
      expect(PushBuildJob).to receive(:enqueue)
      service.call
    end

    Then { expect(repo.active?).to be true }
    And { expect(repo.hook_id).to eq hook_id }
    And { expect(repo.deploy_key_id).to eq deploy_key_id }
  end

  context 'when no recent revision' do
    let(:recent_revision) { '' }

    before { service.call }

    it { expect(PushBuildJob).to_not receive(:enqueue) }
  end
end
