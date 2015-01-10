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
        klass = klass_by_name(klass_name)

        unless klass.source_files.where(path: relative_path(path)).exists?
          source_file = source_file_by_path(path)
          KlassSourceFile.create!(klass_id: klass.id, source_file_id: source_file.id)
        end

        klass.complexity = klass.complexity.to_i + total_score.round

        add_smells(klass)

        klass.save!
      end
    end

    def add_smells(klass)
      flog.method_scores[klass.name].each do |klass_method, score|
        score = score.round
        if score >= HIGH_COMPLEXITY_SCORE_THRESHOLD
          create_smell(klass, klass_method, score)
        end
      end
    end

    def create_smell(klass, klass_method, score)
      path_line = flog.method_locations[klass_method]
      return if path_line.blank?

      path, line = path_line.split(':')
      method_name = klass_method.split('#').last

      smell = Smells::Flog.create!(
        build: build,
        score: score,
        method_name: method_name
      )

      smell.locations.create!(
        path: relative_path(path),
        line: line.to_i
      )

      KlassSmell.create!(klass_id: klass.id, smell_id: smell.id)
    end
  end
end
