require "rails_helper"

describe Analyzers::ReekService do
  let(:push_build) { create :push }

  before do
    stub_build(push_build, "reek")
    described_class.new(push_build).call
  end

  it "creates smells" do
    file = push_build.collections.files["test.rb"]

    smell = file.smells.find { |smell| smell.check_name == "IrresponsibleModule" }
    expect(smell.message).to eq "has no descriptive comment"
    expect(smell.position).to eq 2

    smell = file.smells.find { |smell| smell.check_name == "UnusedParameters" }
    expect(smell.message).to eq "has unused parameter 'unused_param'"
    expect(smell.position).to eq 3
  end
end
