require 'rails_helper'

describe Analyzers::ReekService do
  let(:push_build) { create :push }
  let(:repo) { push_build.branch.repo }
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
    Given(:klass) { repo.klasses.find_by(name: 'DirtyModule::Dirty') }

    Then { expect(klass).to be_present }
    And { expect(repo.source_files.where(path: test_file_path)).to be_exists }

    Given(:klass_smell) { push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: nil) }
    And { expect(klass_smell.message).to eq 'has no descriptive comment' }
    And { expect(klass_smell.locations.where(line: 2)).to be_exists }

    Given(:klass_method_smell) do
      push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: 'test_method')
    end
    And { expect(klass_method_smell.message).to eq "has unused parameter 'unused_param'" }
    And { expect(klass_method_smell.locations.where(line: 3)).to be_exists }
  end

  context 'when tested file has not smells' do
    let(:test_file_path) { path_to_repo_files('reek/clean.rb').to_s }

    When { service.call }
    Then { expect(repo.klasses).to be_empty }
    And { expect(repo.source_files).to be_empty }
    And { expect(push_build.smells).to be_empty }
  end
end
