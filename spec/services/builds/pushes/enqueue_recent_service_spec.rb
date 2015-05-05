require "rails_helper"

describe Builds::Pushes::EnqueueRecentService do
  let(:user) { create :user }
  let(:repo) { create :repo }
  let(:branch) { create :branch, repo: repo }
  let!(:launch_job) { class_spy(Builds::Pushes::LaunchJob, meta_id: 'meta-id').as_stubbed_const }
  let(:api) { instance_double('GithubApi') }

  before do
    allow(service).to receive(:api).and_return(api)
  end

  context 'when has no recent revision' do
    let(:service) { Builds::Pushes::EnqueueRecentService.new(user, repo) }

    before do
      allow(api).to receive(:default_branch).
                      with(repo.full_github_name).
                      and_return('master')

      allow(api).to receive(:recent_revision).
                      with(repo.full_github_name, 'master').
                      and_return(nil)
    end

    Then { expect(service.call).to be_nil }
    And { expect(launch_job).to_not have_received(:enqueue) }
  end

  context 'when has build with same recent revision' do
    let(:service) { Builds::Pushes::EnqueueRecentService.new(user, repo, branch_name: branch.name) }
    let(:prev_build) { create :push, branch: branch }

    before do
      allow(api).to receive(:recent_revision).
                      with(repo.full_github_name, branch.name).
                      and_return(prev_build.revision)
    end

    Then { expect(service.call).to eq 'meta-id' }
    And { expect(launch_job).to have_received(:enqueue).with(repo.id, prev_build.payload.to_json) }
  end

  context 'when has no builds' do
    let(:service) { Builds::Pushes::EnqueueRecentService.new(user, repo, branch_name: branch.name) }
    let(:expected_payload) do
      payload = Payload::Push.new.tap do |payload|
        payload.revision = 'recent-revision'
        payload.branch = branch.name
      end
    end

    before do
      allow(api).to receive(:recent_revision).
                      with(repo.full_github_name, branch.name).
                      and_return('recent-revision')
    end

    Then { expect(service.call).to eq 'meta-id' }
    And { expect(launch_job).to have_received(:enqueue).with(repo.id, expected_payload.to_json) }
  end
end
