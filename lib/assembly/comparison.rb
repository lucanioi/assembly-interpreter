module Assembly
  class Comparison
    def initialize(x, y)
      validate(x, y)
      @x = x
      @y = y
    end

    def greater?
      x > y
    end

    def greater_or_equal?
      x >= y
    end

    def equality?
      x == y
    end

    def less_or_equal?
      x <= y
    end

    def less?
      x < y
    end

    def inequality?
      x != y
    end

    def ==(other)
      x == other.x && y == other.y
    end

    protected

    attr_reader :x, :y

    private

    def validate(x, y)
      unless x.is_a?(Integer) && y.is_a?(Integer)
        raise Errors::InvalidValue, 'x and y must be integers.'
      end
    end
  end

  class NilComparison
    def nil?; true end

    def greater?; false end
    def greater_or_equal?; false end
    def equality?; false end
    def less_or_equal?; false end
    def less?; false end
    def inequality?; false end

    def ==(other)
      other.nil?
    end
  end
end