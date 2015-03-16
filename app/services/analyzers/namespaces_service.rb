module Analyzers
  class NamespacesService < BaseService
    def call
      build.source_locator.paths.each do |path|
        find_namespaces(ProcessedSource.new(path))
      end
    end

    private

    def find_namespaces(processed_source)
      source_file = source_file_by_path(processed_source.path)
      source_file.metric.loc = processed_source.loc

      processed_source.ast.each_node(:module, :class) do |node|
        klass = klass_by_name(node.namespace)

        klass_loc = processed_source.loc(node.first_line..node.last_line)
        klass.metric.increment(:loc, klass_loc)
        klass.metric.increment(:methods_count, count_methods(node))

        unless klass.source_files.where(path: processed_source.path).exists?
          KlassSourceFile.create!(build: build,
                                  klass: klass,
                                  source_file: source_file,
                                  line: node.first_line,
                                  line_end: node.last_line,
                                  loc: klass_loc)
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
  end
end
