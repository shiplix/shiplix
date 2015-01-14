require 'flay'

module Analyzers
  class FlayService < BaseService
    attr_reader :flay

    def call
      @flay = Flay.new

      flay.process(build.source_locator.paths)
    end
  end
end
