module Smells
  class ReekDecorator < SmellDecorator
    def self.title
      "Quality"
    end

    def self.icon
      "fa fa-heartbeat"
    end

    def name
      trait
    end
  end
end