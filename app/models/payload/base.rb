require 'json'

module Payload
  class Base
    pattr_initialize :unparsed_data

    def data
      @data ||= JSON.parse(unparsed_data).with_indifderent_access
    end

    def [](key)
      data[key]
    end
  end
end
