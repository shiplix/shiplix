module Smells
  class ReekDecorator < SmellDecorator
    def self.title
      "Quality"
    end

    def self.icon
      "fa fa-heartbeat"
    end

    def message
      "#{object.check_name.titleize}: #{object.message}"
    end
  end
end
