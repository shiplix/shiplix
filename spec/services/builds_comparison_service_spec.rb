require 'rails_helper'

describe BuildsComparisonService do
  let(:branch) { create :branch }
  let(:target) { create :push, branch: branch }
  let(:source) { create :push, branch: branch }
  let(:service) { described_class.new(target, source) }

  context 'when repo empty' do
    before { service.call }
    it { expect(target.changesets).to be_empty }
  end

  context 'when builds from different repos' do
    let(:source) { create :push }
    it { expect { service.call }.to raise_error }
  end

  describe 'Klass' do
    context 'when has klasses with same rating' do
      before do
        create :klass, name: 'Name', build: target, rating: 1
        create :klass, name: 'Name', build: source, rating: 1
        service.call
      end

      it { expect(target.changesets).to be_empty }
    end

    context 'when has klasses with different rating' do
      before do
        create :klass, name: 'Name', build: target, rating: 1
        create :klass, name: 'Name', build: source, rating: 2
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq target.klasses.first }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to eq 2 }
    end

    context 'when adds new klasses' do
      before do
        create :klass, name: 'Name', build: target, rating: 1
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq target.klasses.first }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to be_nil }
    end
  end

  describe 'SourceFile' do
    context 'when has source files with same rating' do
      before do
        create :source_file, path: 'path/name.rb', build: target, rating: 1
        create :source_file, path: 'path/name.rb', build: source, rating: 1
        service.call
      end

      it { expect(target.changesets).to be_empty }
    end

    context 'when has source files with different rating' do
      before do
        create :source_file, path: 'path/name.rb', build: target, rating: 1
        create :source_file, path: 'path/name.rb', build: source, rating: 2
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq target.source_files.first }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to eq 2 }
    end

    context 'when adds new klasses' do
      before do
        create :source_file, path: 'path/name.rb', build: target, rating: 1
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq target.source_files.first }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to be_nil }
    end
  end
end
