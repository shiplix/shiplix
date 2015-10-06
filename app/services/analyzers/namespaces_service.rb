module Analyzers
  class NamespacesService < BaseService
    def call
      build.source_locator.paths.each do |path|
        @processed_source = ProcessedSource.new(path)
        next if @processed_source.ast.nil? || @processed_source.loc <= 0

        find_namespaces
      end
    end

    private

    def find_namespaces
      file = block_by_path(@processed_source.path)
      file.metrics["loc"] = @processed_source.loc

      @processed_source.ast.each_node(:module, :class) do |node|
        loc = calculate_loc(node)
        next unless loc > 0

        namespace = block_by_name(node.namespace)
        namespace.increment_metric("loc", loc)
        namespace.increment_metric("methods_count", count_methods(node))

        namespace.locations.create!(
          file: file,
          position: Range.new(node.first_line, node.last_line)
        )
      end
    end

    def count_methods(node)
      node.each_descendant(:def, :defs).reduce(0) do |count_methods, method_node|
        parent = method_node.each_ancestor(:class, :module).first
        count_methods += 1 if parent == node
        count_methods
      end
    end

    def calculate_loc(node)
      klass_loc = @processed_source.loc(first_line: node.first_line + 1, last_line: node.last_line - 1)

      klass_loc - inner_loc(node)
    end

    def inner_loc(node)
      node.each_descendant(:class, :module) do |inner_node|
        return @processed_source.loc(first_line: inner_node.first_line, last_line: inner_node.last_line)
      end

      0
    end
  end
end
