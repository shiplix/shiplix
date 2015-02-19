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
      source_file.loc = source.loc

      source.to_ast.namespaces.each do |namespace|
        klass = klass_by_name(namespace.name)

        klass_loc = source.loc_for_namespace(namespace)
        klass.increment(:loc, klass_loc)

        unless klass.source_files.where(path: source.path).exists?
          KlassSourceFile.create!(klass: klass,
                                  source_file: source_file,
                                  line: namespace.line,
                                  line_end: namespace.line_end,
                                  loc: klass_loc)
        end
      end
    end

    class Source
      rattr_initialize :path

      # Public: body of readed file
      #
      # Returns String
      def source
        @source ||= File.read(path)
      end

      # Public: convert source file to Parser::AST::Node
      #
      # Returns Parser::AST::Node or Parser::AST::EmptyNode
      def to_ast
        Parser::CurrentRuby.parse(source) || Parser::AST::EmptyNode.new
      rescue Parser::SyntaxError
        Parser::AST::EmptyNode.new
      end

      # Public: returns LOC for klass in source file
      #
      # namespace - Parser::AST::Node::Namespace
      #
      # Returns integer
      def loc_for_namespace(namespace)
        source.lines[namespace.line - 1..namespace.line_end - 1]
          .reject{ |line| line.strip.blank? }.size
      end

      # Public: returns LOC for source file
      #
      # Returns Integer
      def loc
        source.lines.reject{ |line| line.strip.blank? }.size
      end
    end
  end
end
