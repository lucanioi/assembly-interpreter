module Assembly
  module Instructions
    class Cmp
      def initialize(x, y)
        @x = x
        @y = y
      end

      def execute(program)
        x_val = program.get_register(x)
        y_val = program.get_register(y)
        program.last_cmp = Comparison.new(x_val, y_val)
        program.proceed
      end

      private

      attr_reader :x, :y
    end
  end
end