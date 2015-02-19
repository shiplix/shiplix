require 'rails_helper'

describe RepoSyncService do
  let(:user) { create :user }
  let(:service) { described_class.new(user) }
  let(:api) { double('Api') }

  before { allow(service).to receive(:api).and_return(api) }

  context 'when current repos empty' do
    before do
      create :membership, user: user
      allow(api).to receive(:repos).and_return([])
      service.call
    end

    it { expect(user.repos).to be_empty }
  end

  context 'when current repos present' do
    let(:repo1_attrs) do
      {id: 1, private: true, full_name: 'name1', owner: {type: 'Organization'}, permissions: {admin: true}}
    end

    let(:repo2_attrs) do
      {id: 2, private: true, full_name: 'name2', owner: {type: 'Organization'}, permissions: {admin: false}}
    end

    before do
      repo2 = create :repo, github_id: 2
      repo3 = create :repo, github_id: 3
      create :membership, user: user, repo: repo2, admin: true
      create :membership, user: user, repo: repo3
      allow(api).to receive(:repos).and_return([repo1_attrs, repo2_attrs])
      service.call
    end

    Then { expect(user.repos.count).to eq 2 }
    And { expect(user.memberships.detect { |m| m.repo.github_id == 1 }.admin?).to be true }
    And { expect(user.memberships.detect { |m| m.repo.github_id == 2 }.admin?).to be false }
  end
end