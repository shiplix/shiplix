require "flog"

module Analyzers
  class FlogService < BaseService
    HIGH_COMPLEXITY_SCORE_THRESHOLD = 20
    HIGH_OVERALL_COMPLEXITY_SCORE_THRESHOLD = 200
    BASE_PAIN = 1_000_000
    PAIN_PER_SCORE = 70_000

    def call
      engine = Flog.new(all: true, continue: true)

      @build.source_locator.paths.each do |path|
        engine.reset
        engine.flog(path)
        engine.calculate

        file = find_file(path)
        find_smells(file, engine)
      end
    end

    private

    def find_smells(file, engine)
      total_score = engine.total_score.round
      analyzer_name = "flog".freeze

      if total_score >= HIGH_OVERALL_COMPLEXITY_SCORE_THRESHOLD
        make_smell(file,
                   analyzer: analyzer_name,
                   check_name: "overall".freeze,
                   pain: calculate_pain(total_score),
                   data: {score: total_score})
      end


      file.metrics[:complexity] = total_score

      each_method(engine) do |score, line|
        check_name = line ? "method".freeze : "outside".freeze

        make_smell(file,
                   line: line,
                   analyzer: analyzer_name,
                   check_name: check_name,
                   pain: calculate_pain(score),
                   data: {score: score})
      end
    end

    def each_method(engine)
      engine.totals.each do |meth, score|
        score = score.round
        next if score < HIGH_COMPLEXITY_SCORE_THRESHOLD

        path_line = engine.method_locations[meth]
        line = path_line.split(':').last.to_i if path_line

        yield score, line
      end
    end

    def calculate_pain(score)
      BASE_PAIN + (score - HIGH_COMPLEXITY_SCORE_THRESHOLD) * PAIN_PER_SCORE
    end
  end
end
