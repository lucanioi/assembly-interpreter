require_relative 'instruction'

module Assembly
  module Instructions
    class Mov < Instruction
      def initialize(register, value)
        @register = register
        @value = value
      end

      def execute(program)
        val = program.get_register(value)
        program.set_register(register, val)
        program.proceed
      end

      def ==(other)
        super &&
          register == other.register
          value == other.value
      end

      protected

      attr_reader :register, :value
    end
  end
end
