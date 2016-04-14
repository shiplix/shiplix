require "rails_helper"

describe Builds::LaunchService do
  let(:repo) { create :repo }
  let!(:branch) { create :branch, repo: repo }
  let(:payload) { build 'payload/push' }
  subject(:service) { Builds::LaunchService.new(repo, payload) }

  let!(:scm_update_service) { class_double(ScmUpdateService, new: spy).as_stubbed_const }
  let!(:scm_clean_service) { class_double(ScmCleanService, new: spy).as_stubbed_const }
  let!(:analyze_service) { class_double(Builds::AnalyzeService, new: spy).as_stubbed_const }
  let!(:grade_service) { class_double(Builds::GradeService, new: spy).as_stubbed_const }
  let!(:save_service) { class_double(Builds::SaveService, new: spy).as_stubbed_const }
  let!(:branches_sync_service) { class_double(BranchesSyncService, new: spy).as_stubbed_const }

  it "analyze and finish build" do
    service.call

    expect(service.build.finished?).to be true
    expect(branches_sync_service).to have_received(:new).with(repo)
    expect(scm_update_service).to have_received(:new).with(service.build)
    expect(analyze_service).to have_received(:new).with(service.build)
    expect(grade_service).to have_received(:new).with(service.build)
    expect(save_service).to have_received(:new).with(service.build)
    expect(scm_clean_service).to have_received(:new).with(service.build)
  end

  context 'when build fail' do
    before do
      allow(service).to receive(:analyze).and_raise
    end

    it "marks build as failed and clean scm" do
      expect { service.call }.to raise_error
      expect(service.build.failed?).to be true
      expect(scm_clean_service).to have_received(:new).with(service.build)
    end
  end
end
