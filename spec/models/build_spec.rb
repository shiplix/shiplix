require "rails_helper"

describe Build, type: :model do
  it "generates uid after create" do
    push_build = build :push
    expect { push_build.save }.to change { push_build.uid }
  end
end
