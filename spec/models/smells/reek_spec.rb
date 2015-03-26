require 'rails_helper'

describe Smells::Reek do
  let(:klass) { create :klass, repo: build.branch.repo }
  let(:build) { create :push }

  context 'when create smell with trait' do
    it do
      Reek::Smells::SmellDetector.subclasses.each do |smell_klass|
        trait = smell_klass.name.demodulize
        smell = create :smell_reek, build: build, subject: klass, trait: trait
        expect(smell).to be_persisted
      end
    end
  end
end
