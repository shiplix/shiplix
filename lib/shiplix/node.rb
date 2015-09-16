module Shiplix
  class Node < Astrolabe::Node
    MODULE_TYPES = [:module, :class].freeze

    # Public: find namespace for class or module node
    #
    # Example
    #
    # node.each_node(:class).first.namespace
    #   #=> SomeModule::SomeClass
    #
    # Returns String
    def namespace
      return unless MODULE_TYPES.include?(type)

      name_segments = []
      name_segments << loc.name.source

      each_ancestor(:class, :module) do |node|
        name_segments << node.loc.name.source
      end

      name_segments.reverse.join("::")
    end

    def first_line
      loc.line
    end

    def last_line
      loc.end.line
    end

    # Returns ast Shiplix::Node from line.
    def by_line(line)
      each_node do |node|
        return node if node.loc.expression.try(:line) == line
      end
    end
  end
end
