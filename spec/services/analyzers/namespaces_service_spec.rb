require "rails_helper"

describe Analyzers::NamespacesService do
  let(:push_build) { create :push }

  before do
    stub_build(push_build, "namespaces")
    described_class.new(push_build).call
  end

  it "calculates valid metrics" do
    file = push_build.collections.files["test.rb"]
    expect(file.metrics[:loc]).to eq 23
    expect(file.metrics[:namespaces_count]).to eq 3
    expect(file.metrics[:methods_count]).to eq 4

    file = push_build.collections.files["another.rb"]
    expect(file.metrics[:loc]).to eq 10
    expect(file.metrics[:namespaces_count]).to eq 2
    expect(file.metrics[:methods_count]).to eq 2

    file = push_build.collections.files["rails_generator.rb"]
    expect(file).to be_nil
  end
end
