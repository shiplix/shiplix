module Analyzers
  class ReekService < BaseService
    # Public: process find smells in build
    #
    # Returns nothing
    def call
      paths = build.source_locator.paths
      return if paths.empty?

      Reek::Examiner.new(paths).smells.each do |smell|
        create_smell(smell)
      end
    end

    private

    KLASS_SEPARATOR = '::'.freeze
    METHOD_SEPARATOR = '#'.freeze

    # Internal: scores for reek smells categories
    #
    # see https://github.com/troessner/reek/wiki/Code-Smells
    # and https://github.com/troessner/reek/tree/master/lib/reek/smells
    SMELL_SCORES = {
      'Attribute' => 1,
      'IrresponsibleModule' => 1,
      'BooleanParameter' => 1,
      'ControlParameter' => 1,
      'DataClump' => 1,
      'DuplicateMethodCall' => 1,
      'FeatureEnvy' => 1,
      'LongParameterList' => 1,
      'LongYieldList' => 1,
      'ModuleInitialize' => 1,
      'NestedIterators' => 1,
      'PrimaDonnaMethod' => 1,
      'RepeatedConditional' => 1,
      'TooManyInstanceVariables' => 1,
      'TooManyMethods' => 1,
      'TooManyStatements' => 1,
      'UncommunicativeMethodName' => 1,
      'UncommunicativeParameterName' => 1,
      'UncommunicativeVariableName' => 1,
      'UnusedParameters' => 1,
      'UtilityFunction' => 1
    }

    # Internal: creates smells and locations for this smells
    #
    # Returns nothing
    def create_smell(reek_smell)
      klass = klass_by_name(klass_name_from_context(reek_smell.context))
      method_name = method_name_from_context(reek_smell.context)
      source_file = source_file_by_path(reek_smell.source)

      smell = Smells::Reek.create!(
        build: build,
        subject: klass,
        method_name: method_name,
        message: reek_smell.message,
        score: SMELL_SCORES[reek_smell.smell_type]
      )

      reek_smell.lines.each do |line|
        smell.locations.create!(source_file: source_file, line: line)
      end
    end

    # Internal: find class name from context
    #
    # context - String, like 'A::B::C#d'
    #
    # Example:
    #   klass_name_from_context('A::B::C#d')
    #   # => 'A::B::C'
    #
    # Returns String
    def klass_name_from_context(context)
      context.sub(/#{METHOD_SEPARATOR}.*/, '')
    end

    # Internal: find method name from context
    #
    # context - String, like 'A::B::C#d'
    #
    # Example:
    #   klass_name_from_context('A::B::C#d')
    #   # => 'd'
    #
    # Returns String
    def method_name_from_context(context)
      return unless context.include?(METHOD_SEPARATOR)

      context.split(METHOD_SEPARATOR).last
    end
  end
end
