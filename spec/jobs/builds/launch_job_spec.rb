require "rails_helper"

describe Builds::LaunchJob do
  let(:repo) { create :repo }
  let(:payload) { build 'payload/push' }
  let!(:launch_service) { class_double(Builds::LaunchService, new: spy).as_stubbed_const }

  before { described_class.execute(repo.id, payload.to_json) }

  it { expect(launch_service).to have_received(:new).with(repo, payload) }
end
