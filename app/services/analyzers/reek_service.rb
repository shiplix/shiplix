module Analyzers
  class ReekService < BaseService
    KLASS_SEPARATOR = '::'.freeze
    METHOD_SEPARATOR = '#'.freeze

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
        message: reek_smell.message
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
    #   # => 'C'
    #
    # Returns String
    def klass_name_from_context(context)
      klass_name = context.split(KLASS_SEPARATOR).last
      klass_name.sub(/#{METHOD_SEPARATOR}.*/, '')
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
