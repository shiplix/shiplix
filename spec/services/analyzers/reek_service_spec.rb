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
    stub_build(push_build, repo_path)
    stub_const('Analyzers::ReekService::SMELL_SCORES', smell_scores)
  end

  context 'when tested file has smells' do
    context 'when inspected file has method in klass' do
      let(:repo_path) { "reek/smells" }

      it 'cretes smell for method in klass' do
        service.call

        klass = push_build.namespaces.find_by(name: 'DirtyModule::Dirty')

        expect(klass).to be_present
        expect(push_build.files.where(name: 'dirty.rb')).to be_exists

        klass_smell = klass
                        .smells
                        .where('data @> ?', {method_name: nil}.to_json)
                        .find_by(type: Smells::Reek)

        expect(klass_smell.data['message']).to eq 'has no descriptive comment'
        expect(klass_smell.position).to eq 2...3

        klass_method_smell = klass
                              .smells
                              .where('data @> ?', {method_name: 'test_method'}.to_json)
                              .find_by(type: Smells::Reek)

        expect(klass_method_smell.data['message']).to eq "has unused parameter 'unused_param'"
        expect(klass_method_smell.position).to eq 3...4
      end
    end

    context 'when inspected files has not klasses' do
      let(:repo_path) { "reek/no_classes" }

      it 'creates smell on source file' do
        service.call

        expect(push_build.namespaces).to be_empty
        expect(
          push_build.files.find_by(name: 'without_klasses.rb')
            .smells.where('data @> ?', {method_name: 'settings_list'}.to_json)
        ).to be_exists
      end
    end
  end

  context 'when tested file has not smells' do
    let(:repo_path) { "reek/clean" }

    it "do not create smells" do
      service.call

      expect(push_build.namespaces).to be_empty
      expect(push_build.files).to be_empty
      expect(push_build.smells).to be_empty
    end
  end
end
