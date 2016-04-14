module Smells
  class FlogDecorator < SmellDecorator
    def self.title
      "Complexity"
    end

    def self.icon
      "fa fa-dashboard"
    end

    def message
      case check_name
      when "overall".freeze
        "Very high overall complexity"
      when "outside"
        "Very complex code outside of namespaces"
      when "method"
        "Very complex method"
      end
    end

    def data
      "score = #{object.data['score']}"
    end
  end
end
