require 'flay'

module Analyzers
  class FlayService < BaseService
    THRESHOLD = 25

    def call
      @flay = Flay.new(mass: THRESHOLD).tap do |flay|
        flay.process(*build.source_locator.paths)
        flay.analyze
      end

      analyze
    end

    private

    def analyze
      @flay.hashes.each do |structural_hash, nodes|
        score = @flay.masses[structural_hash]
        make_smells(nodes, score)
      end
    end

    def make_smells(nodes, score)
      nodes.each do |node|
        file = block_by_path(node.file)
        line = node.line
        namespace = block_by_line(file, line)
        next unless namespace

        # TODO: maybe not multiply same namespaces duplication?
        namespace.increment_metric("duplication", score)

        Smells::Flay.create!(
          file: file,
          namespace: namespace,
          position: Range.new(line, line), # TODO: find valid lower bound of range
          data: {"score": score}
        )

        increment_smells(namespace)
      end
    end
  end
end
