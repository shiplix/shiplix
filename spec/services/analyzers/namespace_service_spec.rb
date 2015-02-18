require 'rails_helper'

describe Analyzers::NamespacesService do
  let(:build) { create :push }
  let(:build_dir) { path_to_repo_files('namespace') }

  before do
    stub_build(build, build_dir.to_s)
    described_class.new(build).call
  end

  it 'adds Lib module to build klasses collection' do
    klass = build.collections.klasses['Lib']

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 24
  end

  it 'adds Lib::FirstTestClass to build klasses collection' do
    klass = build.collections.klasses['Lib::FirstTestClass']

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 17
  end

  it 'adds Lib::SecondTestClass to build klasses collection' do
    klass = build.collections.klasses['Lib::SecondTestClass']

    expect(klass).to be_present
    expect(klass.klass_source_files.first.loc).to eq 5
  end

  it 'adds source file to build source files collection' do
    source_file = build.collections.source_files[build_dir.join('lib/test.rb').to_s]

    expect(source_file).to be_present
    expect(source_file.loc).to eq 24
  end
end
