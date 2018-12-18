require_relative 'arithmetic_instruction'

module Assembly
  module Instructions
    class Add < ArithmeticInstruction
      def compute(x_value, y_value)
        x_value + y_value
      end
    end
  end
end