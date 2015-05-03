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

    Then { expect(build.smells_count).to eq 4 }
    And { expect(klass_metrics.for('DirtyModule::Dirty').first.smells_count).to eq 2 }
    And { expect(klass_metrics.for('DirtyModule::Dirty').first.rating).to eq 2 }
    And { expect(klass_metrics.for('FlogTest').first.smells_count).to eq 1 }
    And { expect(klass_metrics.for('FlogTest').first.rating).to eq 2 }
    And { expect(klass_metrics.for('Brakeman').first.smells_count).to eq 1 }
    And { expect(klass_metrics.for('Brakeman').first.rating).to eq 5 }
  end
end
