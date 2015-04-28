module Smells
  class FlayDecorator < SmellDecorator
    def self.title
      "Duplication"
    end

    def self.icon
      "fa fa-files-o"
    end

    def name
      "Code duplication"
    end

    def message
      "Duplication is up to #{score}"
    end
  end
end
