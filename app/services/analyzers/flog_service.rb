require 'flog'

module Analyzers
  class FlogService < BaseService
    HIGH_COMPLEXITY_SCORE_THRESHOLD = 25

    attr_reader :flog

    def call
      @flog = Flog.new(all: true, continue: true, methods: true)

      build.source_locator.paths.each do |path|
        analyze(path)
        calculate(path)
      end
    end

    private

    def analyze(path)
      flog.reset
      flog.flog(path)
      flog.calculate
    end

    def calculate(path)
      flog.scores.each do |klass_name, total_score|
        next unless valid_klass_name?(klass_name)

        klass = klass_by_name(klass_name)
        raise "Klass #{klass_name} not found" unless klass

        source_file = source_file_by_path(path)
        raise "SourceFile #{path} not found" unless source_file

        klass.complexity = klass.complexity.to_i + total_score.round
        klass.save!

        find_smells(klass, source_file)
      end
    end

    def find_smells(klass, source_file)
      flog.method_scores[klass.name].each do |klass_method, score|
        score = score.round
        if score >= HIGH_COMPLEXITY_SCORE_THRESHOLD
          create_smell(klass, klass_method, source_file, score)
        end
      end
    end

    def create_smell(klass, klass_method, source_file, score)
      path_line = flog.method_locations[klass_method]
      return if path_line.blank?

      line = path_line.split(':').last.to_i
      method_name = klass_method.sub('::', '#').split('#').last

      smell = Smells::Flog.create!(
        build_id: build.id,
        subject: klass,
        score: score,
        method_name: method_name
      )

      smell.locations.create!(
        source_file_id: source_file.id,
        line: line
      )
    end

    def valid_klass_name?(klass_name)
      klass_name.split('::').all? { |name| name =~ /^[A-Z]{1}[A-Za-z0-9_]*$/ }
    end
  end
end
