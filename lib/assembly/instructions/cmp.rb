module Assembly
  module Instructions
    class Cmp
      def initialize(x, y)
        @x = x
        @y = y
      end

      def execute(program)
        x_val = x.is_a?(Integer) ? x : program.registry.read(x)
        y_val = y.is_a?(Integer) ? y : program.registry.read(y)
        program.last_cmp = Comparison.new(x_val, y_val)
        program.proceed
      end

      private

      attr_reader :x, :y
    end
  end
end