require 'rails_helper'

describe BuildsComparisonService do
  let(:branch) { create :branch }
  let(:target) { create :push, branch: branch }
  let(:source) { create :push, branch: branch }
  let(:klass) { create :klass, repo: branch.repo }
  let(:source_file) { create :source_file, repo: branch.repo }
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
        create :klass_metric, klass: klass, build: target, rating: 1
        create :klass_metric, klass: klass, build: source, rating: 1
        service.call
      end

      it { expect(target.changesets).to be_empty }
    end

    context 'when has klasses with different rating' do
      before do
        create :klass_metric, klass: klass, build: target, rating: 1
        create :klass_metric, klass: klass, build: source, rating: 2
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq klass }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to eq 2 }
    end

    context 'when adds new klasses' do
      before do
        create :klass_metric, klass: klass, build: target, rating: 1
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq klass }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to be_nil }
    end
  end

  describe 'SourceFile' do
    context 'when has source files with same rating' do
      before do
        create :source_file_metric, source_file: source_file, build: target, rating: 1
        create :source_file_metric, source_file: source_file, build: source, rating: 1
        service.call
      end

      it { expect(target.changesets).to be_empty }
    end

    context 'when has source files with different rating' do
      before do
        create :source_file_metric, source_file: source_file, build: target, rating: 1
        create :source_file_metric, source_file: source_file, build: source, rating: 2
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq source_file }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to eq 2 }
    end

    context 'when adds new klasses' do
      before do
        create :source_file_metric, source_file: source_file, build: target, rating: 1
        service.call
      end

      let(:changeset) { target.changesets.first }

      Then { expect(target.changesets.size).to eq 1 }
      And { expect(changeset.subject).to eq source_file }
      And { expect(changeset.rating).to eq 1 }
      And { expect(changeset.prev_rating).to be_nil }
    end
  end
end
