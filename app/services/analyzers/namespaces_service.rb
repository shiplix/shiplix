require 'ast_node'

module Analyzers
  class NamespacesService < BaseService
    def call
      build.source_locator.paths.each do |path|
        ast_node = parse_file(path)
        find_namespaces(ast_node, path)
      end
    end

    private

    def parse_file(path)
      Parser::CurrentRuby.parse(File.read(path)) || Parser::AST::EmptyNode.new
    rescue Parser::SyntaxError
      Parser::AST::EmptyNode.new
    end

    def find_namespaces(ast_node, path)
      ast_node.namespaces.each do |namespace|
        klass = klass_by_name(namespace.name)
        source_file = source_file_by_path(path)

        unless klass.source_files.where(path: source_file.path).exists?
          KlassSourceFile.create!(klass_id: klass.id,
                                  source_file_id: source_file.id,
                                  line: namespace.line,
                                  line_end: namespace.line_end)
        end
      end
    end
  end
end
