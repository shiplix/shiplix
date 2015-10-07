module Builds
  module Pushes
    class AnalyzeService < ApplicationService
      pattr_initialize :build

      attr_reader :build

      ANALYZERS = [
        Analyzers::NamespacesService,
        Analyzers::FlogService,
        Analyzers::FlayService,
        Analyzers::ReekService,
        Analyzers::BrakemanService,
        Analyzers::RatingService
      ]

      def call
        ANALYZERS.each { |analyzer| analyzer.new(build).call }
      end
    end
  end
end
