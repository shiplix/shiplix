require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }
  let(:build_dir) { path_to_repo_files('namespace') }

  before do
    stub_build(build, build_dir.to_s)
    described_class.new(build).call
  end

  it 'calculates code metrics on module Lib' do
    klass = build.collections.klasses['Lib']

    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 23
    expect(klass.klass_source_files.by_path('lib/another.rb').loc).to eq 10
    expect(klass.loc).to eq 33
    expect(klass.methods_count).to eq 1
  end

  it 'calculates code metrics on Lib::Test::FirstTestClass' do
    klass = build.collections.klasses['Lib::Test::FirstTestClass']

    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 14
    expect(klass.klass_source_files.by_path('lib/another.rb').loc).to eq 4
    expect(klass.loc).to eq 18
    expect(klass.methods_count).to eq 4
  end

  it 'calculates code metrics on Lib::Test::SecondTestClass' do
    klass = build.collections.klasses['Lib::Test::SecondTestClass']

    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 5
    expect(klass.loc).to eq 5
    expect(klass.methods_count).to eq 1
  end

  it 'calculates loc on source files' do
    source_files = build.collections.source_files

    test_rb = source_files[build_dir.join('lib/test.rb').to_s]
    another_rb = source_files[build_dir.join('lib/another.rb').to_s]

    expect(test_rb.loc).to eq 23
    expect(another_rb.loc).to eq 10
  end
end
