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
        create_smell(warn)
      end

    rescue Brakeman::NoApplication
      # no-op
    end

    private

    def create_smell(warn)
      if (klass_name = klass_name_from_warning(warn)).present?
        klass = klass_by_name(klass_name)
      end

      source_file = source_file_by_path(warn.relative_path)

      smell = Smells::Brakeman.create!(
        build: build,
        subject: klass || source_file,
        method_name: warn.method.to_s,
        message: warn.message,
        trait: warn.warning_type
      )

      # NOTE: brakeman can return line as nil
      smell.locations.create!(source_file: source_file, line: warn.line.to_i)
    end

    def klass_name_from_warning(warn)
      warn.class || warn.controller || warn.model
    end
  end
end
