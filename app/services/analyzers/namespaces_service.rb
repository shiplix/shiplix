module Analyzers
  class NamespacesService < BaseService
    def call
      build.source_locator.paths.each do |path|
        @processed_source = ProcessedSource.new(path)
        next if @processed_source.ast.nil?

        find_namespaces
      end
    end

    private

    def find_namespaces
      source_file = source_file_by_path(@processed_source.path)
      source_file.metric.loc = @processed_source.loc

      @processed_source.ast.each_node(:module, :class) do |node|
        klass = klass_by_name(node.namespace)
        klass_loc = calculate_klass_loc(node)

        klass.metric.increment(:loc, klass_loc)
        klass.metric.increment(:methods_count, count_methods(node))

        if klass_loc > 0 && !klass.source_file_in_build(build, @processed_source.path).exists?
          KlassSourceFile.create!(
            build: build,
            klass: klass,
            source_file: source_file,
            line: node.first_line,
            line_end: node.last_line,
            loc: klass_loc
          )
        end
      end
    end

    def count_methods(node)
      node.each_descendant(:def, :defs).reduce(0) do |count_methods, method_node|
        parent = method_node.each_ancestor(:class, :module).first
        count_methods += 1 if parent == node
        count_methods
      end
    end

    def calculate_klass_loc(node)
      klass_loc = @processed_source.loc(first_line: node.first_line + 1, last_line: node.last_line - 1)

      klass_loc - inner_klass_loc(node)
    end

    def inner_klass_loc(node)
      node.each_descendant(:class, :module) do |inner_node|
        return @processed_source.loc(first_line: inner_node.first_line, last_line: inner_node.last_line)
      end

      0
    end
  end
end
