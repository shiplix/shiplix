require 'rails_helper'

describe Smells::Flog do
  describe '#rating' do
    let(:smell) { build_stubbed :smell_flog, :with_class, score: 100_500 }

    it { expect(smell.rating).to eq 5 }
  end
end
