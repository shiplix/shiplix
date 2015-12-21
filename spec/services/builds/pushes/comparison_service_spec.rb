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

  context "when adds new klass in new file" do
    let!(:new_klass) { create "namespace_block", build: target_build, rating: 1 }
    let!(:new_file) { create "file_block", build: target_build, rating: 1 }

    before do
      service.call
    end

    subject(:changesets) { target_build.changesets }

    it "creates new changeset for new klass and new file" do
      expect(changesets.exists?(block_id: new_klass.id, prev_block_id: nil)).to eq true
      expect(changesets.exists?(block_id: new_file.id, prev_block_id: nil)).to eq true
      expect(changesets.size).to eq 2
    end
  end

  context 'when rating in klass and file was not change' do
    before do
      create "namespace_block", name: 'TestKlass', build: target_build, rating: 1
      create "file_block", name: 'test_klass.rb', build: target_build, rating: 1

      create "namespace_block", name: 'TestKlass', build: source_build, rating: 1
      create "file_block", name: 'test_klass.rb', build: source_build, rating: 1

      service.call
    end

    it { expect(target_build.changesets).to be_empty }
  end

  context 'when rating in klass was change' do
    let!(:target_klass) { create "namespace_block", name: 'TestKlass', build: target_build, rating: 1 }
    let!(:source_klass) { create "namespace_block", name: 'TestKlass', build: source_build, rating: 2 }
    let!(:another_klass) { create "namespace_block", name: 'AnotherKlass', build: source_build, rating: 2 }

    let!(:target_file) { create "file_block", name: 'test.rb', build: target_build, rating: 1 }
    let!(:source_file) { create "file_block", name: 'test.rb', build: source_build, rating: 1 }
    let!(:another_file) { create "file_block", name: 'another_klass.rb', build: source_build, rating: 2 }

    it 'create changeset only for klass' do
      service.call

      expect(target_build.changesets.size).to eq 1
      expect(target_build.changesets.exists?(block_id: target_klass.id, prev_block_id: source_klass.id)).to eq true
    end
  end
end
