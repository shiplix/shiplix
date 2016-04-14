module Analyzers
  class ReekService < BaseService
    # Public: process find smells in build
    #
    # Returns nothing
    def call
      paths = @build.source_locator.paths
      return if paths.empty?

      # TODO: in new version examinder back to Reek::Examiner, but this
      # version not yet relized
      # see: https://github.com/troessner/reek/pull/532/files
      Reek::Core::Examiner.new(paths).smells.each do |smell|
        process_smell(smell)
      end
    end

    private

    # Creates smells and locations for Reek::Smells::SmellWarning.
    #
    # Returns nothing.
    def process_smell(reek_smell)
      file = find_file(reek_smell.source)

      reek_smell.lines.each do |line|
        make_smell(file,
                   line: line,
                   analyzer: "reek".freeze,
                   check_name: reek_smell.smell_type,
                   message: reek_smell.message)
      end
    end
  end
end
