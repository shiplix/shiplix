module Analyzers
  class NamespacesService < BaseService
    def call
      @build.source_locator.paths.each do |path|
        @processed_source = ProcessedSource.new(path)
        next if @processed_source.ast.nil? || @processed_source.loc <= 0

        find_namespaces
      end
    end

    private

    def find_namespaces
      file = find_file(@processed_source.path)

      file.metrics[:loc] = @processed_source.loc
      file.metrics[:namespaces_count] = 0
      file.metrics[:methods_count] = 0

      @processed_source.ast.each_node(:module, :class) do |node|
        loc = calculate_loc(node)
        next unless loc > 0

        file.metrics[:namespaces_count] += 1
        file.metrics[:methods_count] += count_methods(node)
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
