require 'rails_helper'

describe SourceLocator, fakefs: true do
  before do
    FileUtils.mkdir_p '/tmp/repo/app'

    FileUtils.touch '/tmp/repo/first_ruby_file.rb'
    FileUtils.touch '/tmp/repo/not_ruby_file.txt'
    FileUtils.touch '/tmp/repo/app/second_ruby_file.rb'
    FileUtils.touch '/tmp/repo/app/not_ruby_file.js'
  end

  describe '#paths' do
    context 'when SourceLocator creates to folder path' do
      subject(:source_locator) { described_class.new('/tmp/repo') }

      it 'returns array of paths to ruby files' do
        expect(source_locator.paths).to match_array(
          %w(/tmp/repo/first_ruby_file.rb  /tmp/repo/app/second_ruby_file.rb)
        )
      end
    end

    context 'when SourceLocator creates to file' do
      context 'when path to ruby file' do
        subject(:source_locator) { described_class.new('/tmp/repo/first_ruby_file.rb') }

        it { expect(source_locator.paths).to eq ['/tmp/repo/first_ruby_file.rb'] }
      end

      context 'when path to not ruby file' do
        subject(:source_locator) { described_class.new('/tmp/repo/not_ruby_file.txt') }

        it { expect(source_locator.paths).to eq [] }
      end
    end
  end
end
