require 'flay'

module Analyzers
  class FlayService < BaseService
    attr_reader :flay

    def call
      @flay = Flay.new

      flay.process(*build.source_locator.paths)
      flay.analyze

      analyze
    end

    private

    def analyze
      flay.hashes.each do |structural_hash, nodes|
        score = flay.masses[structural_hash]
        smells = find_smells(nodes, score)
        attach_locations(smells, nodes) if smells.any?
      end
    end

    def find_smells(nodes, score)
      nodes.each_with_object({}) do |node, smells|
        source_file = source_file_by_path(node.file)
        klass = klass_by_line(source_file, node.line)
        next unless klass

        smells[klass.id] ||= Smells::Flay.create!(
          build_id: build.id,
          subject: klass,
          score: score
        )
      end
    end

    def attach_locations(smells, nodes)
      smells.each do |_id, smell|
        nodes.each do |node|
          source_file = source_file_by_path(node.file)
          smell.locations.create!(source_file: source_file, line: node.line)
        end
      end
    end
  end
end
