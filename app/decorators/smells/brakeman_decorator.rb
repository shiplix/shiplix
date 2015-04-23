module Smells
  class BrakemanDecorator < SmellDecorator
    def self.title
      "Security"
    end

    def self.icon
      "fa-bug"
    end

    def name
      trait
    end
  end
end
