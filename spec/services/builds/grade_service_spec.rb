require "rails_helper"

RSpec.describe Builds::GradeService do
  let(:push_build) { create :push }
  let(:file1) { push_build.collections.find_file("test1.rb") }
  let(:file2) { push_build.collections.find_file("test2.rb") }

  it "gets an estimate" do
    file1.pain = 100
    file2.pain = 3_000_000
    described_class.new(push_build).call

    expect(file1.grade).to eq "A"
    expect(file2.grade).to eq "B"
    expect(push_build.gpa).to eq 3.5
  end
end
