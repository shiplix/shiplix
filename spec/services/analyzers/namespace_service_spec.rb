require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }
  let(:repo) { build.branch.repo }

  before do
    stub_build(build, 'namespace')
    described_class.new(build).call
  end

  it 'calculates code metrics on module Lib' do
    namespace = build.collections.blocks['Lib']

    expect(namespace.files.where(name: 'lib/test.rb')).not_to be_exists
    expect(namespace.metrics['loc']).to eq 2
    expect(namespace.metrics['methods_count']).to eq 1
  end

  it 'calculates code metrics on Lib::Test::FirstTestClass' do
    namespace = build.collections.blocks['Lib::Test::FirstTestClass']

    expect(namespace.metrics['loc']).to eq 14
    expect(namespace.metrics['methods_count']).to eq 4
  end

  it 'calculates code metrics on Lib::Test::SecondTestClass' do
    namespace = build.collections.blocks['Lib::Test::SecondTestClass']

    expect(namespace.metrics['loc']).to eq 3
    expect(namespace.metrics['methods_count']).to eq 1
  end

  it 'calculates loc on files' do
    test_rb = build.collections.blocks['lib/test.rb']
    another_rb = build.collections.blocks['lib/another.rb']

    expect(test_rb.metrics['loc']).to eq 23
    expect(another_rb.metrics['loc']).to eq 10
  end

  it 'not find metrics for files without code' do
    expect(build.collections.blocks.keys).not_to include 'lib/without_code.rb'
  end

  it 'not find metrics for rails generators' do
    expect(build.collections.blocks.keys).not_to include 'lib/rails_generator.rb'
  end
end
