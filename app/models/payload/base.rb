require 'json'

module Payload
  class Base
    pattr_initialize :unparsed_data

    def data
      @data ||= JSON.parse(unparsed_data).with_indifferent_access
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
    end

    def as_json(*)
      data.as_json
    end
  end
end
