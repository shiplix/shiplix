module Analyzers
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
    end

    private

    def create_smell(warn)
      klass_name = warn.class || warn.model
      klass = klass_by_name(klass_name.to_s)

      smell = Smells::Brakeman.create!(
        build: build,
        subject: klass,
        method_name: warn.method.to_s,
        message: warn.message
      )

      if warn.line.present?
        source_file = source_file_by_path(warn.file)
        smell.locations.create!(source_file: source_file, line: warn.line)
      end
    end
  end
end
