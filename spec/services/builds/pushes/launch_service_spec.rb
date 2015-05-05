require 'rails_helper'

describe Builds::Pushes::LaunchService do
  let(:repo) { create :repo }
  let!(:branch) { create :branch, repo: repo }
  let(:payload) { build 'payload/push' }
  let(:service) { Builds::Pushes::LaunchService.new(repo, payload) }

  let!(:scm_update_service) { class_double(ScmUpdateService, new: spy).as_stubbed_const }
  let!(:scm_clean_service) { class_double(ScmCleanService, new: spy).as_stubbed_const }
  let!(:analyze_service) { class_double(Builds::Pushes::AnalyzeService, new: spy).as_stubbed_const }
  let!(:branches_sync_service) { class_double(BranchesSyncService, new: spy).as_stubbed_const }
  let!(:comparison_job) { class_spy(Builds::Pushes::ComparisonJob).as_stubbed_const }

  context 'when has no finished builds' do
    before { service.call }

    Then { expect(service.build.finished?).to be true }
    And { expect(branches_sync_service).to have_received(:new).with(repo) }
    And { expect(scm_update_service).to have_received(:new).with(service.build) }
    And { expect(analyze_service).to have_received(:new).with(service.build) }
    And { expect(scm_clean_service).to have_received(:new).with(service.build) }
    And { expect(comparison_job).to_not have_received(:enqueue) }

    context 'when has finished builds' do
      let!(:prev_build) { create :push, branch: branch }
      let(:payload) { build "payload/push", prev_revision: prev_build.revision }

      Then { expect(comparison_job).to have_received(:enqueue).with(service.build.id, prev_build.id) }
    end
  end

  context 'when build fail' do
    before do
      allow(service).to receive(:analyze).and_raise
    end

    Then { expect { service.call }.to raise_error }
    And { expect(service.build.failed?).to be true }
    And { expect(scm_clean_service).to have_received(:new).with(service.build) }
  end
end
