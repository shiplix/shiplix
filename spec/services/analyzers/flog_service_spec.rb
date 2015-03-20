require 'rails_helper'

describe Analyzers::FlogService do
  let(:repo) { create :repo, full_github_name: 'flog' }
  let(:branch) { create :branch, repo: repo }
  let(:build) { create :push, branch: branch, revision: 'revision' }
  let(:service) { described_class.new(build) }
  let(:klasses) { repo.klasses.index_by(&:name) }

  before { service.call }

  Then { expect(klasses['FlogTest']).to be_present }
  And { expect(klasses['FlogTest'].smells.size).to eq 1 }
end
