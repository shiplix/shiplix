module Shiplix
  class Builder < Parser::Builders::Default
    def n(type, children, source_map)
      Shiplix::Node.new(type, children, location: source_map)
    end
  end
end
