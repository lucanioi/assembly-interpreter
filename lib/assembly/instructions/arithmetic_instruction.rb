require_relative 'instruction'

module Assembly
  module Instructions
    class ArithmeticInstruction < Instruction
      def initialize(target_register, source_register)
        @target_register = target_register
        @source_register = source_register
      end

      def execute(program, operator)
        x_value = program.get_register(target_register)
        y_value = program.get_register(source_register)
        value = x_value.send(operator, y_value)

        program.set_register(target_register, value)
        program.proceed
      end

      def ==(other)
        target_register == other.target_register &&
          source_register == other.source_register &&
          super
      end

      protected

      attr_reader :target_register, :source_register
    end
  end
end