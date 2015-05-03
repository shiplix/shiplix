require 'json'

module Payload
  class Base
    attr_reader :data

    def initialize(data = nil)
      data = JSON.parse(data) if data.is_a?(String)
      @data = (data || {}).with_indifferent_access
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
    end

    def ==(other)
      to_json == other.to_json
    end

    def as_json(*)
      data.as_json
    end
  end
end
