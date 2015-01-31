require 'rails_helper'

describe Analyzers::BrakemanService do
  let(:build) { create :push }

  context "when repo looks like rails app" do
    before do
      stub_build(build, path_to_repo_files('brakeman').to_s)
      described_class.new(build).call
    end

    it "creates smell for dirty_controller" do
      klass = build.klasses.find_by(name: "Brakeman::DirtyController")
      smell = Smells::Brakeman.find_by(build: build, subject: klass, method_name: "redirect_to_some_places")
      source_file = build.source_files.find_by(name: "dirty_controller.rb")

      expect(klass).to be_present
      expect(smell).to be_present
      expect(source_file).to be_present
      expect(smell.locations.where(source_file: source_file, line: 4)).to be_exists
    end

    it "creates smell for application_controller" do
      klass = build.klasses.find_by(name: "ApplicationController")
      smell = Smells::Brakeman.find_by(build: build, subject: klass)
      source_file = build.source_files.find_by(name: "application_controller.rb")

      expect(klass).to be_present
      expect(smell).to be_present
      expect(source_file).to be_present
      expect(smell.locations.where(source_file: source_file, line: 0)).to be_exists
    end

    it "creates smells for model" do
      klass = build.klasses.find_by(name: "Brakeman::Account")
      smell = Smells::Brakeman.find_by(build: build, subject: klass)
      source_file = build.source_files.find_by(name: "account.rb")

      expect(klass).to be_present
      expect(smell).to be_present
      expect(source_file).to be_present
      expect(smell.locations.where(source_file: source_file, line: 0)).to be_exists
    end

    it "creates smell for view" do
      source_file = build.source_files.find_by(name: "index.html.erb")
      smell = Smells::Brakeman.find_by(build: build, subject: source_file)

      expect(source_file).to be_present
      expect(smell).to be_present
      expect(smell.locations.where(source_file: source_file, line: 2)).to be_exists
    end
  end

  context 'when repo not rails app' do
    before do
      stub_build(build, path_to_repo_files('not_existing_rails_app'))
    end

    it { expect { described_class.new(build).call }.not_to raise_error }
  end
end
