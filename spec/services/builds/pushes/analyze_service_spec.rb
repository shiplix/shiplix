require "rails_helper"

describe Builds::Pushes::AnalyzeService do
  let(:build) { create :push }
  let(:service) { Builds::Pushes::AnalyzeService.new(build) }

  before do
    stub_build(build, path_to_repo_files('push_build'))
  end

  context 'when save build collections' do
    let(:klass_metrics) { build.klass_metrics }

    before { service.call }

    it "saves statistics" do
      expect(build.smells_count).to eq 4
      expect(build.rating_smells_count).to eq 1
      expect(build.total_rating).to eq 2

      metric = klass_metrics.for('DirtyModule::Dirty').first
      expect(metric.smells_count).to eq 2
      expect(metric.rating_smells_count).to eq 0
      expect(metric.total_rating).to eq 0

      metric = klass_metrics.for('FlogTest').first
      expect(metric.smells_count).to eq 1
      expect(metric.rating_smells_count).to eq 1
      expect(metric.total_rating).to eq 2

      metric = klass_metrics.for('Brakeman').first
      expect(metric.smells_count).to eq 1
      expect(metric.rating_smells_count).to eq 0
      expect(metric.total_rating).to eq 0
    end
  end
end
