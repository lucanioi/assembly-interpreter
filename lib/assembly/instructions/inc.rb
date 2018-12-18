require_relative 'instruction'

module Assembly
  module Instructions
    class Inc < Instruction
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value + 1)
        program.proceed
      end

      def ==(other)
        super && register == other.register
      end

      private

      attr_reader :register
    end
  end
end
