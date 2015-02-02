require 'rails_helper'

describe RepoDeactivatorService do
  let(:repo) { create :repo, hook_id: 111, deploy_key_id: 222 }
  let(:user) { create :user }
  let(:service) { described_class.new(user, repo) }
  let(:api) { double('Api') }

  before do
    create(:membership, user: user, repo: repo)

    allow(api).to receive(:remove_hooks).and_return(true)
    allow(api).to receive(:remove_deploy_key).and_return(true)
    allow(service).to receive(:api).and_return(api)
  end

  context 'when deactivating repo' do
    before { service.call }

    Then { expect(repo.active?).to be false }
    And { expect(repo.hook_id).to be_nil }
    And { expect(repo.deploy_key_id).to be_nil }
  end
end
