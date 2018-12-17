require_relative 'arithmetic_instruction'

module Assembly
  module Instructions
    class Mul < ArithmeticInstruction
      def execute(program)
        super(program, :*)
      end
    end
  end
end