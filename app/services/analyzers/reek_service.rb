module Analyzers
  class ReekService < BaseService
    METHOD_SEPARATOR = '#'.freeze

    # Public: process find smells in build
    #
    # Returns nothing
    def call
      paths = build.source_locator.paths
      return if paths.empty?

      @processed_sources = {}

      # TODO: in new version examinder back to Reek::Examiner, but this
      # version not yet relized
      # see: https://github.com/troessner/reek/pull/532/files
      Reek::Core::Examiner.new(paths).smells.each do |smell|
        @processed_sources[smell.source] ||= ProcessedSource.new(smell.source)

        make_smell(smell)
      end
    end

    private

    # Creates smells and locations for Reek::Smells::SmellWarning.
    #
    # Returns nothing.
    def make_smell(reek_smell)
      file = block_by_path(reek_smell.source)

      reek_smell.lines.each do |line|
        if smell_on_method_without_class?(line, reek_smell.source)
          namespace = nil
          method_name = reek_smell.context
        else
          namespace = block_by_name(block_name_from_context(reek_smell.context))
          method_name = method_name_from_context(reek_smell.context)
        end

        Smells::Reek.create!(
          namespace: namespace,
          file: file,
          position: Range.new(line, line),
          data: {
            "message": reek_smell.message,
            "method_name": method_name,
            "smell_type": reek_smell.smell_type
          }
        )

        increment_smells(namespace || file)
      end
    end

    def smell_on_method_without_class?(line, path)
      ast_node = @processed_sources[path].ast.by_line(line)

      (ast_node.def_type? || ast_node.defs_type?) && ast_node.each_ancestor(:class, :module).count.zero?
    end

    # Internal: find class name from context
    #
    # context - String, like 'A::B::C#d'
    #
    # Example:
    #   klass_name_from_context('A::B::C#d')
    #   # => 'A::B::C'
    #
    # Returns String
    def block_name_from_context(context)
      context.sub(/#{METHOD_SEPARATOR}.*/, '')
    end

    # Internal: find method name from context
    #
    # context - String, like 'A::B::C#d'
    #
    # Example:
    #   method_name_from_context('A::B::C#d')
    #   # => 'd'
    #
    # Returns String
    def method_name_from_context(context)
      return unless context.include?(METHOD_SEPARATOR)

      context.split(METHOD_SEPARATOR).last
    end
  end
end
