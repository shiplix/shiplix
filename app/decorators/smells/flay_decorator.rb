module Smells
  class FlayDecorator < SmellDecorator
    def self.title
      "Duplication".freeze
    end

    def self.icon
      "fa fa-files-o".freeze
    end

    def message
      msg = case check_name
            when "identical".freeze
              "Identical"
            when "similiar".freeze
              "Similiar"
            end

      locations_count = object.data.fetch("other_locations", {}).size
      msg << " code found in #{locations_count} other " << "location".pluralize(locations_count)
    end

    def data
      res = ["mass = #{object.data['mass']}"]
      res << object.data.fetch("other_locations", {}).map { |path, line| "#{path}:#{line}" }.join(", ").presence
      res.join(", ")
    end
  end
end
