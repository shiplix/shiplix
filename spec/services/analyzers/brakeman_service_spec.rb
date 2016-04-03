require "rails_helper"

describe Analyzers::BrakemanService do
  let(:push_build) { create :push }

  context "when repo looks like rails app" do
    before do
      stub_build(push_build, "brakeman")
      described_class.new(push_build).call
    end

    it "creates smell for dirty_controller" do
      file = push_build.collections.files["app/controllers/dirty_controller.rb"]
      smell = file.smells.find { |smell| smell.check_name == "Redirect" }

      expect(smell.data[:confidence]).to eq 0
      expect(smell.position).to eq 4
    end

    it "creates smell for application_controller" do
      file = push_build.collections.files["app/controllers/application_controller.rb"]
      smell = file.smells.find { |smell| smell.check_name == "Cross-Site Request Forgery" }

      expect(smell.data[:confidence]).to eq 0
      expect(smell.position).to eq 0
    end

    it "creates smells for model" do
      file = push_build.collections.files["app/models/account.rb"]
      smell = file.smells.find { |smell| smell.check_name == "Mass Assignment" }

      expect(smell.data[:confidence]).to eq 0
      expect(smell.position).to eq 0
    end

    it "creates smell for view" do
      file = push_build.collections.files["app/views/index.html.erb"]
      smell = file.smells.find { |smell| smell.check_name == "Cross Site Scripting" }

      expect(smell.data[:confidence]).to eq 0
      expect(smell.position).to eq 2
    end
  end

  context "when repo not rails app" do
    before do
      stub_build(push_build, "not_existing_rails_app")
    end

    it { expect { described_class.new(push_build).call }.not_to raise_error }
  end
end
