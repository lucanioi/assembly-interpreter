require_relative 'instruction'

module Assembly
  module Instructions
    class ArithmeticInstruction < Instruction
      def initialize(target_register, source_register)
        @target_register = target_register
        @source_register = source_register
      end

      def execute(program)
        x_value = program.get_register(target_register)
        y_value = program.get_register(source_register)
        value = compute(x_value, y_value)

        program.set_register(target_register, value)
        program.proceed
      end

      def ==(other)
        super &&
        target_register == other.target_register &&
        source_register == other.source_register
      end

      protected

      attr_reader :target_register, :source_register

      private

      def compute(x_value, y_value)
        raise NotImplementedError
      end
    end
  end
end