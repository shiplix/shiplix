require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }

  before do
    stub_build(build, path_to_repo_files('namespace').to_s)
  end

  before do
    described_class.new(build).call
  end

  it 'creates namespace for root module Lib' do
    klass = build.klasses.find_by(name: 'Lib')

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 24
  end

  it 'creates namespace for FirstTestClass' do
    klass = build.klasses.find_by(name: 'Lib::FirstTestClass')

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 17
  end

  it 'creates namespace for SecondTestClass' do
    klass = build.klasses.find_by(name: 'Lib::SecondTestClass')

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 5
  end
end
