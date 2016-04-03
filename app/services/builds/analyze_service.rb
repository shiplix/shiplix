module Builds
  class AnalyzeService < ApplicationService
    attr_initialize :build

    def call
      services.each { |analyzer| analyzer.new(@build).call }
    end

    private

    def services
      [
        Analyzers::NamespacesService,
        Analyzers::FlogService,
        Analyzers::FlayService,
        Analyzers::ReekService,
        Analyzers::BrakemanService
      ]
    end
  end
end
