require 'rails_helper'

describe Analyzers::ReekService do
  let(:push_build) { create :push }
  let(:smell_scores) do
    {
      'IrresponsibleModule' => 10,
      'UnusedParameters' => 5
    }
  end

  subject(:service) { described_class.new(push_build) }

  before do
    stub_build(push_build, test_file_path)
    stub_const('Analyzers::ReekService::SMELL_SCORES', smell_scores)
  end

  context 'when tested file has smells' do
    let(:test_file_path) { path_to_repo_files('reek/dirty.rb').to_s }

    When { service.call }
    Given(:klass) { push_build.klasses.find_by(name: 'DirtyModule::Dirty') }

    Then { expect(klass).to be_present }
    And { expect(push_build.source_files.where(path: test_file_path)).to be_exists }

    Given(:klass_smell) { push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: nil) }
    And { expect(klass_smell.message).to eq 'has no descriptive comment' }
    And { expect(klass_smell.locations.where(line: 2)).to be_exists }
    And { expect(klass_smell.score).to eq 10 }

    Given(:klass_method_smell) do
      push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: 'test_method')
    end
    And { expect(klass_method_smell.message).to eq "has unused parameter 'unused_param'" }
    And { expect(klass_method_smell.locations.where(line: 3)).to be_exists }
    And { expect(klass_method_smell.score).to eq 5 }
  end

  context 'when tested file has not smells' do
    let(:test_file_path) { path_to_repo_files('reek/clean.rb').to_s }

    When { service.call }
    Then { expect(push_build.klasses).to be_empty }
    And { expect(push_build.source_files).to be_empty }
    And { expect(push_build.smells).to be_empty }
  end
end
