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

        rating = rating.round + 1
        total_rating += rating
        total_blocks += 1
        block.rating = rating
        block.save!
      end

      build.rating = (total_rating / total_blocks.to_f).round if total_blocks > 0
    end

    private

    # http://jakescruggs.blogspot.ru/2008/08/whats-good-flog-score.html
    def complexity_rate(score)
      if score < 25
        0
      elsif score < 40
        1
      elsif score < 60
        2
      elsif score < 100
        3
      else
        4
      end
    end

    def duplication_rate(score)
      if score < 25
        0
      elsif score < 50
        1
      elsif score < 100
        2
      elsif score < 200
        3
      else
        4
      end
    end
  end
end
