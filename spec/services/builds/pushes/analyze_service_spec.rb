require "rails_helper"

describe Builds::Pushes::AnalyzeService do
  let(:build) { create :push }
  let(:service) { Builds::Pushes::AnalyzeService.new(build) }

  before do
    stub_build(build, 'push_build')
  end

  context 'when save build collections' do
    let(:klass_metrics) { build.klass_metrics }

    before { service.call }

    it "saves statistics" do
      expect(build.smells_count).to eq 4
      expect(build.rating).to eq 1.5

      namespace = Blocks::Namespace.find_by(name: 'DirtyModule::Dirty')
      expect(namespace.smells_count).to eq 2
      expect(namespace.rating).to eq 1

      namespace = Blocks::Namespace.find_by(name: 'FlogTest')
      expect(namespace.smells_count).to eq 1
      expect(namespace.rating).to eq 2.5

      namespace = Blocks::Namespace.find_by(name: 'Brakeman')
      expect(namespace.smells_count).to eq 1
    end
  end
end
