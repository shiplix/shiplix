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
      flog.scores.each do |name, total_score|
        next unless valid_name?(name)

        namespace = block_by_name(name)
        file = block_by_path(path)
        namespace.increment_metric("complexity", total_score.round)
        find_smells(namespace, file)
      end
    end

    def find_smells(namespace, file)
      flog.method_scores[namespace.name].each do |method_name, score|
        score = score.round
        namespace.increment_metric("complexity", score)

        if score >= HIGH_COMPLEXITY_SCORE_THRESHOLD
          make_smell(namespace, method_name, file, score)
        end
      end
    end

    def make_smell(namespace, method_name, file, score)
      path_line = flog.method_locations[method_name]
      return if path_line.blank?

      line = path_line.split(':').last.to_i
      method_name = method_name.sub('::', '#').split('#').last

      Smells::Flog.create!(
        namespace: namespace,
        file: file,
        position: Range.new(line, line),
        data: {
          "score": score,
          "method_name": method_name
        }
      )

      increment_smells(namespace)
    end

    def valid_name?(name)
      name.split('::').all? { |x| x =~ /^[A-Z]{1}[A-Za-z0-9_]*$/ }
    end
  end
end
