require 'rails_helper'

describe Analyzers::FlogService do
  let(:repo) { create :repo, name: 'flog' }
  let(:payload) { build "payload/push", revision: "revision" }
  let(:branch) { create :branch, repo: repo }
  let(:push_build) { create :push, branch: branch, payload: payload }
  let(:service) { described_class.new(push_build) }

  subject(:namespaces) { push_build.namespaces.index_by(&:name) }

  before { stub_build(push_build, 'flog') }

  it 'creates klass with smell' do
    service.call

    expect(namespaces['FlogTest']).to be_present
    expect(namespaces['FlogTest'].smells.size).to eq 1
  end
end
