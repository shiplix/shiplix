require 'rails_helper'

describe RepoActivatorService do
  let(:user) { create :user }
  let(:repo) { create :repo }
  let(:service) { described_class.new(user, repo) }
  let(:api) { instance_double('GithubApi') }
  let(:hook_id) { 111 }
  let!(:recent_service) { class_double('Builds::EnqueueRecentService', new: spy).as_stubbed_const }

  before do
    create(:membership, user: user, repo: repo)

    allow(service).to receive(:api).and_return(api)
    allow(api).to receive(:add_hooks).and_yield(hook_id)

    service.call
  end

  Then { expect(repo.active?).to be true }
  And { expect(repo.hook_id).to eq hook_id }
  And { expect(recent_service).to have_received(:new).with(user, repo) }
end
