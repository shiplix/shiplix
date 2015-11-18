require 'rails_helper'

describe Analyzers::FlayService do
  let(:build) { create :push }

  before do
    stub_build(build, path_to_repo_files('flay').to_s)
  end

  context 'when we have knowledge about klass in database' do
    before { Analyzers::NamespacesService.new(build).call }

    it 'creates smells for dublication code' do
      described_class.new(build).call

      klass = build.collections.blocks['Flay::DirtyClass']

      created_smells = klass.smells.where(type: Smells::Flay)
      smells_start_positions = created_smells.map(&:position).map(&:first)

      expect(smells_start_positions).to match_array [3, 10]
      expect(klass.metrics['duplication']).to eq 108
    end
  end

  context 'when we does not have knowledge about klass in database' do
    it 'does not create smells' do
      described_class.new(build).call

      expect(Blocks::Namespace.exists?).to eq false
      expect(Smells::Flay.exists?).to eq false
    end
  end
end
