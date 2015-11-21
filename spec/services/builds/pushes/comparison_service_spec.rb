require 'rails_helper'

describe Builds::Pushes::ComparisonService do
  let(:branch) { create :branch }
  let(:target_build) { create :push, branch: branch }
  let(:source_build) { create :push, branch: branch }
  let(:service) { described_class.new(target_build, source_build) }

  context 'when repo empty' do
    before { service.call }
    it { expect(target_build.changesets).to be_empty }
  end

  context 'when builds from different repos' do
    let(:source_build) { create :push }
    it { expect { service.call }.to raise_error }
  end

  context 'when creates klass and file together' do
    let!(:new_file) { create "file_block", build: target_build, rating: 1 }
    let!(:new_klass) { create "namespace_block", build: target_build, rating: 1 }

    it 'creates changesets for file and klass' do
      service.call

      expect(target_build.changesets.size).to eq 2
      expect(target_build.changesets.map(&:block)).to match_array [new_file, new_klass]
      expect(target_build.changesets.map(&:prev_block)).to match_array [nil, nil]
    end
  end

  [:namespace, :file].each do |source|
    describe "#{source}" do
      context 'when has klasses with same rating' do
        before do
          create "#{source}_block", build: target_build, rating: 1
          create "#{source}_block", build: source_build, rating: 1

          service.call
        end

        it { expect(target_build.changesets).to be_empty }
      end

      context "when has #{source} with different rating" do
        let!(:target_klass) { create "#{source}_block", build: target_build, rating: 1 }
        let!(:source_klass) { create "#{source}_block", build: source_build, rating: 2 }

        before { service.call }

        subject(:changeset) { target_build.changesets.first }

        it "saves changeset for that #{source}" do
          expect(changeset.block).to eq target_klass
          expect(changeset.prev_block).to eq source_klass
        end
      end

      context "when adds new #{source}" do
        let!(:new_klass) { create "#{source}_block", build: target_build, rating: 1 }

        before do
          service.call
        end

        let(:changeset) { target_build.changesets.first }

        it "creates new changeset for new #{source}" do
          expect(target_build.changesets.size).to eq 1
          expect(changeset.block).to eq new_klass
          expect(changeset.prev_block).to be_nil
        end
      end
    end
  end
end
