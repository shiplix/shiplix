module Plans
  class Free
    def active
      true
    end

    def name
      'Free'.freeze
    end

    def price
      0
    end

    def repo_limit
      0
    end

    def month
      0
    end

    def free?
      true
    end
  end
end
