require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }
  let(:repo) { build.branch.repo }
  let(:build_dir) { path_to_repo_files('namespace') }

  before do
    stub_build(build, build_dir.to_s)
    described_class.new(build).call
  end

  it 'calculates code metrics on module Lib' do
    klass = build.collections.klasses['Lib']

    expect(klass.klass_source_files.by_path('lib/test.rb')).not_to be_exists
    expect(klass.klass_source_files.by_path('lib/another.rb').first.loc).to eq 2
    expect(klass.metric.loc).to eq 2
    expect(klass.metric.methods_count).to eq 1
  end

  it 'calculates code metrics on Lib::Test::FirstTestClass' do
    klass = build.collections.klasses['Lib::Test::FirstTestClass']

    expect(klass.klass_source_files.by_path('lib/test.rb').first.loc).to eq 12
    expect(klass.klass_source_files.by_path('lib/another.rb').first.loc).to eq 2
    expect(klass.metric.loc).to eq 14
    expect(klass.metric.methods_count).to eq 4
  end

  it 'calculates code metrics on Lib::Test::SecondTestClass' do
    klass = build.collections.klasses['Lib::Test::SecondTestClass']

    expect(klass.klass_source_files.by_path('lib/test.rb').first.loc).to eq 3
    expect(klass.metric.loc).to eq 3
    expect(klass.metric.methods_count).to eq 1
  end

  it 'calculates loc on source files' do
    source_files = build.collections.source_files

    test_rb = source_files['lib/test.rb']
    another_rb = source_files['lib/another.rb']

    expect(test_rb.metric.loc).to eq 23
    expect(another_rb.metric.loc).to eq 10
  end

  it 'not find metrics for files without code' do
    expect(build.collections.source_files.keys).not_to include 'lib/without_code.rb'
  end
end
