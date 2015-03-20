module Smells
  class Flog < Smell
    # TODO: ???
    # http://jakescruggs.blogspot.ru/2008/08/whats-good-flog-score.html
    def rating
      if score < 40
        2
      elsif score < 60
        3
      elsif score < 100
        4
      else
        5
      end
    end
  end
end
