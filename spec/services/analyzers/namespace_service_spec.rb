require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }
  let(:build_dir) { path_to_repo_files('namespace') }

  before do
    stub_build(build, build_dir.to_s)
    described_class.new(build).call
  end

  it 'calculates loc on module Lib' do
    klass = build.collections.klasses['Lib']

    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 24
    expect(klass.klass_source_files.by_path('lib/another.rb').loc).to eq 6
    expect(klass.loc).to eq 30
  end

  it 'calculates loc on Lib::FirstTestClass' do
    klass = build.collections.klasses['Lib::FirstTestClass']

    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 17
    expect(klass.klass_source_files.by_path('lib/another.rb').loc).to eq 4
    expect(klass.loc).to eq 21
  end

  it 'calculates loc on Lib::SecondTestClass' do
    klass = build.collections.klasses['Lib::SecondTestClass']

    expect(klass).to be_present
    expect(klass.klass_source_files.by_path('lib/test.rb').loc).to eq 5
  end

  it 'calculates loc on source files' do
    source_files = build.collections.source_files

    test_rb = source_files[build_dir.join('lib/test.rb').to_s]
    another_rb = source_files[build_dir.join('lib/another.rb').to_s]

    expect(test_rb.loc).to eq 24
    expect(another_rb.loc).to eq 6
  end
end
