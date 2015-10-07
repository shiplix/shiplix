module Analyzers
  # run brakeman analyzer for build
  # see https://github.com/presidentbeef/brakeman
  class BrakemanService < BaseService
    def call
      tracker = Brakeman.run(
        app_path: build.revision_path.to_s,
        parallel_checks: false,
        min_confidence: 0
      )

      tracker.warnings.each do |warn|
        make_smell(warn)
      end
    rescue Brakeman::NoApplication
      # no-op
    end

    private

    def make_smell(warn)
      if (namespace = namespace_from_warning(warn)).present?
        namespace = block_by_name(namespace)
      end

      file = block_by_path(warn.relative_path)
      line = warn.line.to_i

      Smells::Brakeman.create!(
        namespace: namespace,
        file: file,
        position: Range.new(line, line),
        data: {
          "confidence": warn.confidence,
          "warning_type": warn.warning_type
        }
      )

      increment_smells(namespace || file)
    end

    def namespace_from_warning(warn)
      warn.class || warn.controller || warn.model
    end
  end
end
