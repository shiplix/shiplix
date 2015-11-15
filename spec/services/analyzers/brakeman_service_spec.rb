require 'rails_helper'

describe Analyzers::BrakemanService do
  let(:build) { create :push }
  let(:repo) { build.branch.repo }

  context "when repo looks like rails app" do
    before do
      stub_build(build, path_to_repo_files('brakeman').to_s)
      described_class.new(build).call
    end

    it "creates smell for dirty_controller" do
      klass = build.namespaces.find_by(name: "Brakeman::DirtyController")

      smell = klass
                .smells
                .where('data @> ?', {method_name: 'redirect_to_some_places'}.to_json)
                .find_by(type: Smells::Brakeman)

      expect(klass).to be_present
      expect(smell.file.name).to eq 'app/controllers/dirty_controller.rb'
      expect(smell.position.first).to eq 4
    end

    it "creates smell for application_controller" do
      klass = build.namespaces.find_by(name: "ApplicationController")

      expect(klass).to be_present
      expect(klass.smells.first.file.name).to eq 'app/controllers/application_controller.rb'
      expect(klass.smells.first.position.first).to eq 0
    end

    it "creates smells for model" do
      klass = build.namespaces.find_by(name: "Brakeman::Account")

      expect(klass).to be_present
      expect(klass.smells.first.file.name).to eq 'app/models/account.rb'
      expect(klass.smells.first.position.first).to eq 0
    end

    it "creates smell for view" do
      file = build.files.find_by(name: "app/views/index.html.erb")

      expect(file).to be_present
      expect(file.smells).to be_exists(type: Smells::Brakeman)
      expect(file.smells.first.position.first).to eq 2
    end
  end

  context 'when repo not rails app' do
    before do
      stub_build(build, path_to_repo_files('not_existing_rails_app'))
    end

    it { expect { described_class.new(build).call }.not_to raise_error }
  end
end
