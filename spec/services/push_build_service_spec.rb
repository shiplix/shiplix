require 'rails_helper'

describe PushBuildService do
  let(:repo) { create :repo, full_github_name: 'push_build' }
  let(:branch) { create :branch, repo: repo }
  let(:payload) { build 'payload/push', revision: "revision" }
  let(:service) { described_class.new(branch, payload) }

  let!(:scm_update_service) { class_double(ScmUpdateService, new: spy).as_stubbed_const }
  let!(:scm_clean_service) { class_double(ScmCleanService, new: spy).as_stubbed_const }
  let!(:builds_comparison_job) { class_spy(PushBuildsComparisonJob).as_stubbed_const }
  let(:klasses) { repo.klasses.index_by(&:name) }

  context 'when has no finished builds' do
    before { service.call }

    Then { expect(service.build.finished?).to be true }
    And { expect(scm_update_service).to have_received(:new).with(service.build) }
    And { expect(scm_clean_service).to have_received(:new).with(service.build) }
    And { expect(builds_comparison_job).to_not have_received(:enqueue) }
  end

  context 'when has finished builds' do
    let!(:prev_build) { create :push, branch: branch }
    let(:payload) { build "payload/push", prev_revision: prev_build.revision, revision: "revision" }

    before do
      prev_build.finish!
      service.call
    end

    Then { expect(service.build.finished?).to be true }
    And { expect(scm_update_service).to have_received(:new).with(service.build) }
    And { expect(scm_clean_service).to have_received(:new).with(service.build) }
    And { expect(builds_comparison_job).to have_received(:enqueue).with(service.build.id, prev_build.id) }
  end

  context 'when build fail' do
    before do
      allow(service).to receive(:analyze).and_raise
    end

    Then { expect { service.call }.to raise_error }
    And { expect(service.build.failed?).to be true }
    And { expect(scm_clean_service).to have_received(:new).with(service.build) }
  end

  context 'when save build collections' do
    let(:klass_metrics) { service.build.klass_metrics }
    before { service.call }

    Then { expect(service.build.smells_count).to eq 4 }
    And { expect(klass_metrics.for('DirtyModule::Dirty').first.smells_count).to eq 2 }
    And { expect(klass_metrics.for('DirtyModule::Dirty').first.rating).to eq 2 }
    And { expect(klass_metrics.for('FlogTest').first.smells_count).to eq 1 }
    And { expect(klass_metrics.for('FlogTest').first.rating).to eq 2 }
    And { expect(klass_metrics.for('Brakeman').first.smells_count).to eq 1 }
    And { expect(klass_metrics.for('Brakeman').first.rating).to eq 5 }
  end
end
