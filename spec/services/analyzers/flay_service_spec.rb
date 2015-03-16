require 'rails_helper'

describe Analyzers::FlayService do
  let(:build) { create :push }
  let(:repo) { build.branch.repo }

  before do
    stub_build(build, path_to_repo_files('flay').to_s)
  end

  context 'when we have knowledge about klass in database' do
    let!(:klass) do
      create :klass_in_file,
             line: 2,
             line_end: 4,
             path: 'dirty.rb',
             name: 'Flay::Dirty',
             build: build,
             repo: repo
    end
    let(:source_file) { klass.source_files.first }

    it 'creates smell' do
      described_class.new(build).call

      smell = klass.smells.find_by(type: Smells::Flay)

      expect(smell.locations.where(source_file: source_file, line: 3)).to be_exists
      expect(smell.locations.where(source_file: source_file, line: 10)).to be_exists
    end
  end

  context 'when we does not have knowledge about klass in database' do
    it 'does not create smells' do
      described_class.new(build).call

      expect(Klass.all).to be_empty
      expect(Smells::Flay.all).to be_empty
    end
  end
end
