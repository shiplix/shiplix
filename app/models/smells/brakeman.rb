module Smells
  class Brakeman < Smell
    SCORE_RATING = [5, 4, 3]

    def rating
      SCORE_RATING[score]
    end
  end
end
