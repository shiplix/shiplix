module Smells
  class BrakemanDecorator < SmellDecorator
    def self.title
      "Security"
    end

    def self.icon
      "fa fa-lock"
    end

    def message
      object.check_name.titleize
    end
  end
end
