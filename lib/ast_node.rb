require 'parser/ast/node'

module Parser
  module AST
    class Node
      class Namespace
        vattr_initialize :name, :line, :line_end

        def to_s
          name
        end

        def inspect
          "#{name} #{line}:#{line_end}"
        end
      end

      MODULE_TYPES = [:module, :class].freeze

      def count_nodes_of_type(*types)
        count = 0
        recursive_children do |child|
          count += 1 if types.include?(child.type)
        end
        count
      end

      def recursive_children
        children.each do |child|
          next unless child.is_a?(Parser::AST::Node)
          yield child
          child.recursive_children { |grand_child| yield grand_child }
        end
      end

      def namespaces
        children_namespaces = children_nodes.flat_map { |child| child.namespaces }

        if MODULE_TYPES.include?(type)
          namespace = Namespace.new(namespace_name, loc.line, loc.end.line)

          [namespace] + children_namespaces.map do |child_namespace|
            name = "#{namespace_name}::#{child_namespace}"
            Namespace.new(name, child_namespace.line, child_namespace.line_end)
          end
        elsif children_namespaces.empty?
          []
        else
          children_namespaces
        end
      end

      def children_nodes
        children.select { |child| child.is_a?(Parser::AST::Node) }
      end

      def namespace_name
        name_segments = []
        current_node = children[0]
        while current_node do
          name_segments.unshift(current_node.children[1])
          current_node = current_node.children[0]
        end
        name_segments.join("::")
      end
    end

    class EmptyNode
      def count_nodes_of_type(*types)
        0
      end

      def namespaces
        []
      end
    end
  end
end
