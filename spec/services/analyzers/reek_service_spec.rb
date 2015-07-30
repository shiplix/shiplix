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
    context 'when inspected file has method in klass' do
      let(:test_file_path) { path_to_repo_files('reek/dirty.rb').to_s }

      it 'cretes smell for method in klass' do
        service.call

        klass = repo.klasses.find_by(name: 'DirtyModule::Dirty')

        expect(klass).to be_present
        expect(repo.source_files.where(path: test_file_path)).to be_exists

        klass_smell = push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: nil)

        expect(klass_smell.message).to eq 'has no descriptive comment'
        expect(klass_smell.locations.where(line: 2)).to be_exists

        klass_method_smell = push_build.smells.find_by(type: Smells::Reek, subject: klass, method_name: 'test_method')

        expect(klass_method_smell.message).to eq "has unused parameter 'unused_param'"
        expect(klass_method_smell.locations.where(line: 3)).to be_exists
      end
    end

    context 'when inspected files has not klasses' do
      let(:test_file_path) { path_to_repo_files('reek/without_klasses.rb').to_s }

      it 'creates smell on source file' do
        service.call

        expect(repo.klasses).to be_empty
        expect(repo.source_files.find_by(path: test_file_path).smells)
          .to be_exists(method_name: 'settings_list')
      end
    end
  end

  context 'when tested file has not smells' do
    let(:test_file_path) { path_to_repo_files('reek/clean.rb').to_s }

    When { service.call }
    Then { expect(repo.klasses).to be_empty }
    And { expect(repo.source_files).to be_empty }
    And { expect(push_build.smells).to be_empty }
  end
end
