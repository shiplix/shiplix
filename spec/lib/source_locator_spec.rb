require 'rails_helper'

describe SourceLocator do
  before do
    FileUtils.mkdir_p 'tmp/repo/app'

    FileUtils.touch 'tmp/repo/first_ruby_file.rb'
    FileUtils.touch 'tmp/repo/not_ruby_file.txt'
    FileUtils.touch 'tmp/repo/app/second_ruby_file.rb'
    FileUtils.touch 'tmp/repo/app/not_ruby_file.js'
  end

  after do
    FileUtils.rm_rf('tmp/repo')
  end

  describe '#paths' do
    subject(:source_locator) { described_class.new('tmp/repo', paths) }

    context "when provided an empty array" do
      let(:paths) { [] }

      it { expect(source_locator.paths).to be_empty }
    end

    context "when provided mask by app folder" do
      let(:paths) { ['app/**/*.rb'] }

      it do
        expect(source_locator.paths).to match_array(['tmp/repo/app/second_ruby_file.rb'])
      end
    end

    context "when provided mask by app and root folders" do
      let(:paths) { ['app/**/*.rb', '*.rb'] }

      it do
        expect(source_locator.paths).
          to match_array(['tmp/repo/app/second_ruby_file.rb', 'tmp/repo/first_ruby_file.rb'])
      end
    end
  end
end
