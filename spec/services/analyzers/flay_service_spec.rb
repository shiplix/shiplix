require "rails_helper"

describe Analyzers::FlayService do
  let(:push_build) { create :push }
  let(:file) { push_build.collections.files["test.rb"] }

  before do
    stub_build(push_build, "flay")
    described_class.new(push_build).call
  end

  context "when find smells" do
    it "writes metrics in file" do
      expect(file.metrics[:duplication]).to eq 108
      expect(file.pain).to eq 8_800_000
      expect(file.smells.size).to eq 2
    end

    it "creates smell with similiar duplication" do
      smells = file.smells.select { |smell| smell.check_name == "similiar" }.sort_by(&:position)

      expect(smells[0].pain).to eq 4_400_000
      expect(smells[0].position).to eq 3
      expect(smells[0].data[:mass]).to eq 54

      expect(smells[1].pain).to eq 4_400_000
      expect(smells[1].position).to eq 10
      expect(smells[1].data[:mass]).to eq 54
    end
  end
end
