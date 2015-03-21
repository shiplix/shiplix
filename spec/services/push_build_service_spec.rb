require 'rails_helper'

describe PushBuildService do
  let(:repo) { create :repo, full_github_name: 'push_build' }
  let(:branch) { create :branch, repo: repo }
  let(:service) { described_class.new(branch, 'revision') }
  let(:build) { service.build }
  let!(:scm_update_service) { class_double(ScmUpdateService, new: spy).as_stubbed_const }
  let!(:scm_clean_service) { class_double(ScmCleanService, new: spy).as_stubbed_const }
  let!(:build_comparison_service) { class_double(BuildsComparisonService, new: spy).as_stubbed_const }
  let(:klasses) { repo.klasses.index_by(&:name) }

  context 'when has no finished builds' do
    before { service.call }

    Then { expect(build.finished?).to be true }
    And { expect(scm_update_service).to have_received(:new).with(build) }
    And { expect(scm_clean_service).to_not have_received(:new) }
    And { expect(build_comparison_service).to_not have_received(:new) }
  end

  context 'when has finished builds' do
    let(:last_build) { create :push, branch: branch }

    before do
      last_build.finish!
      service.call
    end

    Then { expect(build.finished?).to be true }
    And { expect(scm_update_service).to have_received(:new).with(build) }
    And { expect(scm_clean_service).to have_received(:new).with(last_build) }
    And { expect(build_comparison_service).to have_received(:new).with(build, last_build) }
  end

  context 'when build fail' do
    before do
      allow(service).to receive(:analyze).and_raise
    end

    Then { expect { service.call }.to raise_error }
    And { expect(build.failed?).to be true }
    And { expect(scm_clean_service).to have_received(:new).with(build) }
  end

  context 'when calc metrics' do
    before { service.call }

    Then { expect(build.smells_count).to eq 3 }
    And { expect(build.klass_metrics.for('DirtyModule::Dirty').first.smells_count).to eq 2 }
    And { expect(build.klass_metrics.for('FlogTest').first.smells_count).to eq 1 }
    And { expect(build.klass_metrics.for('FlogTest').first.rating).to eq 2 }
  end
end
