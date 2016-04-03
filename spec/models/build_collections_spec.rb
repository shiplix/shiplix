require "rails_helper"

RSpec.describe BuildCollections do
  let(:push_build) { create :push }
  let(:file_path) { Rails.root.join("spec/fixtures/owner/repo/app/test.rb").to_s }
  subject(:collection) { described_class.new(push_build) }

  before do
    stub_build(push_build, "owner/repo")
  end

  describe "#find_file" do
    it "finds or creates raw file by relative path" do
      file = collection.find_file(file_path)
      expect(file.path).to eq "app/test.rb"
      expect(file.smells).to be_empty
      expect(file.metrics).to be_empty
      expect(file.pain).to eq 0
      expect(file.grade).to eq "A"
    end

    it "creates file once" do
      file = collection.find_file(file_path)
      expect(collection.find_file(file_path).object_id).to eq file.object_id
    end
  end

  describe "#make_smell" do
    it "makes new smell" do
      file = collection.find_file(file_path)

      smell = collection.make_smell(file,
                                    line: 3,
                                    analyzer: "flog",
                                    check_name: "overall",
                                    message: "msg",
                                    pain: 4,
                                    data: {score: 5})

      expect(smell.position).to eq 3
      expect(smell.analyzer).to eq "flog"
      expect(smell.check_name).to eq "overall"
      expect(smell.message).to eq "msg"
      expect(smell.pain).to eq 4
      expect(smell.data[:score]).to eq 5

      expect(file.smells.size).to eq 1
    end
  end
end
