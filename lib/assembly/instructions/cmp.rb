module Assembly
  module Instructions
    class Cmp
      def initialize(x, y)
        @x = x
        @y = y
      end

      def execute(program)
        program.last_cmp = Comparison.new(x, y)
        program.proceed
      end

      private

      attr_reader :x, :y
    end
  end
end