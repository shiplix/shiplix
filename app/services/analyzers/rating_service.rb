module Analyzers
  class RatingService < BaseService
    def call
      total_rating = total_blocks = 0

      build.collections.blocks.each do |_name, block|
        next unless block.is_a?(Blocks::Namespace)

        # TODO: use LOC in formula
        rating = (
                    complexity_rate(block.metrics["complexity"].to_i) +
                    duplication_rate(block.metrics["duplication"].to_i)
                  ) /
                 2.to_f

        total_rating += rating
        total_blocks += 1
        block.rating = rating.round(2)
        block.save!
      end

      build.rating = (total_rating.to_f / total_blocks).round(2) if total_blocks > 0
    end

    private

    # http://jakescruggs.blogspot.ru/2008/08/whats-good-flog-score.html
    def complexity_rate(score)
      if score < 25
        1
      elsif score < 40
        2
      elsif score < 60
        3
      elsif score < 100
        4
      else
        5
      end
    end

    def duplication_rate(score)
      if score < 25
        1
      elsif score < 50
        2
      elsif score < 100
        3
      elsif score < 200
        4
      else
        5
      end
    end
  end
end
