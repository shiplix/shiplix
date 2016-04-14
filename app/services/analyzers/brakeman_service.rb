module Analyzers
  # run brakeman analyzer for build
  # see https://github.com/presidentbeef/brakeman
  class BrakemanService < BaseService
    def call
      tracker = Brakeman.run(
        app_path: @build.revision_path.to_s,
        parallel_checks: false,
        min_confidence: 0
      )

      tracker.warnings.each do |warn|
        process_warning(warn)
      end
    rescue Brakeman::NoApplication
      # no-op
    end

    private

    def process_warning(warn)
      make_smell(find_file(warn.relative_path),
                 line: warn.line.to_i,
                 analyzer: "brakeman".freeze,
                 check_name: warn.warning_type,
                 data: {confidence: warn.confidence})
    end
  end
end
