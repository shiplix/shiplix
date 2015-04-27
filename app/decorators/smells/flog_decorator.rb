module Smells
  class FlogDecorator < SmellDecorator
    def self.title
      "Complexity"
    end

    def self.icon
      "fa fa-dashboard"
    end

    def name
      'Code complexity'
    end

    def message
      "Complexity is up to #{score}"
    end
  end
end
