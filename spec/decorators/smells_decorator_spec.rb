require 'rails_helper'

RSpec.describe SmellsDecorator do
  describe '#source_grouped' do
    let(:location) { create :location, position: 1..10 }

    let(:namespace) { location.namespace }
    let(:file) { location.file }

    let!(:smell_reek_1) do
      create :smell_reek, namespace: namespace, file: file, position: 1..2
    end

    let!(:smell_reek_2) do
      create :smell_reek, namespace: namespace, file: file, position: 5..6
    end

    let!(:smell_flog) do
      create :smell_flog, namespace: namespace, file: file, position: 2..3
    end

    subject(:grouped_smells) { namespace.smells.decorate.source_grouped }

    it { expect(grouped_smells[location.file.name]['Smells::Reek'].size).to eq 2}
    it { expect(grouped_smells[location.file.name]['Smells::Flog'].size).to eq 1}
  end
end
