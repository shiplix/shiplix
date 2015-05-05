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
        Analyzers::BrakemanService
      ]

      def call
        transaction do
          ANALYZERS.each { |analyzer| analyzer.new(build).call }
          build.collections.save
        end
      end

      protected

      def transaction
        inner_exception = nil

        build.transaction do
          begin
            yield
          rescue ActiveRecord::Rollback => e
            inner_exception = e
            raise
          end
        end

        raise inner_exception if inner_exception
      end
    end
  end
end
