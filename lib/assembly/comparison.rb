require_relative 'assembly_error'

module Assembly
  class Comparison
    InvalidValue = Class.new(AssemblyError)

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
        raise InvalidValue, 'x and y must be integers.'
      end
    end
  end
end