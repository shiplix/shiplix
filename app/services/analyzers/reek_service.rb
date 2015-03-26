module Analyzers
  class ReekService < BaseService
    # Public: process find smells in build
    #
    # Returns nothing
    def call
      paths = build.source_locator.paths
      return if paths.empty?

      Reek::Examiner.new(paths).smells.each do |smell|
        make_smell(smell)
      end
    end

    private

    KLASS_SEPARATOR = '::'.freeze
    METHOD_SEPARATOR = '#'.freeze

    # Internal: creates smells and locations for this smells
    #
    # Returns nothing
    def make_smell(reek_smell)
      klass = klass_by_name(klass_name_from_context(reek_smell.context))
      method_name = method_name_from_context(reek_smell.context)
      source_file = source_file_by_path(reek_smell.source)

      smell = create_smell(
        Smells::Reek,
        klass,
        method_name: method_name,
        message: reek_smell.message,
        trait: reek_smell.smell_type
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
