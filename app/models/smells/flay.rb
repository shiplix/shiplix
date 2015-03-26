module Smells
  class Flay < Smell
    def rating
      if score < 50
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
