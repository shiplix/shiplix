require 'flay'

module Analyzers
  class FlayService < BaseService
    attr_reader :flay

    def call
      @flay = Flay.new

      flay.process(build.source_locator.paths)
      flay.analyze
    end

    private

    def analyze
      flay.hashes.each do |key, nodes|
        smells = {}

        node.each do |node|
          source_file = source_file_by_path(node.file)
          klass = source_file.klass_by_line(node.line)

          smells[node.file] ||= Smells::Flay.create!(
            klass_id: klass.id
            source_file_id: source_file.id,
            score: score
          )

          smells[node.file].locations.create!(source_file: source_file, line: node.line)
        end
      end
    end
  end
end
