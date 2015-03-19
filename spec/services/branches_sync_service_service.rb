require 'rails_helper'

describe BranchesSyncService do
  let(:user) { create :user }
  let(:repo) { create :repo }
  let(:service) { described_class.new(repo) }
  let(:branches) { repo.branches.index_by(&:name) }
  let!(:scm_clean_service) { class_double(ScmCleanService, new: spy).as_stubbed_const }

  before do
    create :membership, repo: repo, user: user, admin: true
  end

  context 'when add branches' do
    before do
      allow(service).to receive(:api_branches).and_return('master' => double, 'develop' => double)
      allow(service).to receive(:api_default_branch).and_return('master')
      service.call
      repo.branches.reload
    end

    Then { expect(branches.size).to eq 2 }
    And { expect(branches['master']).to be_default }
    And { expect(branches['develop']).to_not be_default }
  end

  context 'when remove branches' do
    let(:deleted_branch) { create :branch, repo: repo, name: 'release', default: false }
    let(:last_build) { create :push, branch: deleted_branch }

    before do
      create :branch, repo: repo, name: 'master', default: true
      last_build.finish!

      allow(service).to receive(:api_branches).and_return('master' => double, 'develop' => double)
      allow(service).to receive(:api_default_branch).and_return('develop')
      service.call
      repo.branches.reload
    end

    Then { expect(branches.size).to eq 2 }
    And { expect(branches['master']).to_not be_default }
    And { expect(branches['develop']).to be_default }
    And { expect(scm_clean_service).to have_received(:new).with(last_build) }
  end
end
