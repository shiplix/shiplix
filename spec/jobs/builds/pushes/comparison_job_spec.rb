require "rails_helper"

describe Builds::Pushes::ComparisonJob do
  let(:branch) { create :branch }
  let(:target) { create :push, branch: branch }
  let(:source) { create :push, branch: branch }
  let!(:comparison_service) { class_double(Builds::Pushes::ComparisonService, new: spy).as_stubbed_const }

  before { described_class.execute(target.id, source.id) }

  it { expect(comparison_service).to have_received(:new).with(target, source) }
end
