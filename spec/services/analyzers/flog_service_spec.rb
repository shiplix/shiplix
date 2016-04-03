require "rails_helper"

describe Analyzers::FlogService do
  let(:push_build) { create :push }
  let(:file) { push_build.collections.files["test.rb"] }

  before do
    stub_build(push_build, "flog")
    described_class.new(push_build).call
  end

  context "when find smells" do
    it "writes metrics in file" do
      expect(file.metrics[:complexity]).to eq 230
      expect(file.pain).to eq 30_510_000
      expect(file.smells.size).to eq 3
    end

    it "creates smell with overall complexity" do
      smell = file.smells.find { |smell| smell.check_name == "overall" }
      expect(smell.pain).to eq 15_700_000
      expect(smell.position).to eq 0
      expect(smell.data[:score]).to eq 230
    end

    it "creates smell with outside complexity" do
      smell = file.smells.find { |smell| smell.check_name == "outside" }
      expect(smell.pain).to eq 12_970_000
      expect(smell.position).to eq 0
      expect(smell.data[:score]).to eq 191
    end

    it "creates smell with method complexity" do
      smell = file.smells.find { |smell| smell.check_name == "method" }
      expect(smell.pain).to eq 1_840_000
      expect(smell.position).to eq 2
      expect(smell.data[:score]).to eq 32
    end
  end
end
