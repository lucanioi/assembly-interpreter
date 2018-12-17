require_relative 'arithmetic_instruction'

module Assembly
  module Instructions
    class Div < ArithmeticInstruction
      def execute(program)
        super(program, :/)
      end
    end
  end
end