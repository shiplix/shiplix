# require 'parser/current'
# require 'ast_node'

# class ContextLocator
#   pattr_initialize :context

#   def first_name
#     names.first
#   end

#   def names
#     return name_from_path if context.methods_count.zero?

#     names = node.get_module_names
#     if names.empty?
#       name_from_path
#     else
#       names
#     end
#   end

#   private

#   def node
#     Parser::CurrentRuby.parse(content) || Parser::AST::EmptyNode.new
#   rescue Parser::SyntaxError
#     Parser::AST::EmptyNode.new
#   end

#   def content
#     File.read(context.path)
#   end

#   def name_from_path
#     [file_name.split("_").map(&:capitalize).join]
#   end

#   def file_name
#     context.pathname.basename.sub_ext("").to_s
#   end
# end
