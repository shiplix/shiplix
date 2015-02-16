require 'ast_node'

module Analyzers
  class NamespacesService < BaseService
    def call
      build.source_locator.paths.each do |path|
        find_namespaces(Source.new(path))
      end
    end

    private

    def find_namespaces(source)
      source_file = source_file_by_path(source.path)

      source.to_ast.namespaces.each do |namespace|
        klass = klass_by_name(namespace.name)

        unless klass.source_files.where(path: source.path).exists?
          KlassSourceFile.create!(klass_id: klass.id,
                                  source_file_id: source_file.id,
                                  line: namespace.line,
                                  line_end: namespace.line_end,
                                  loc: source.loc_for_namespace(namespace))
        end
      end
    end

    class Source
      attr_initialize :path
      attr_reader :path

      def source
        @source ||= File.read(path)
      end

      def to_ast
        Parser::CurrentRuby.parse(source) || Parser::AST::EmptyNode.new
      rescue Parser::SyntaxError
        Parser::AST::EmptyNode.new
      end

      def loc_for_namespace(namespace)
        source.lines[namespace.line - 1..namespace.line_end - 1]
          .each.reject{ |line| line.strip.blank? }.size
      end
    end
  end
end
