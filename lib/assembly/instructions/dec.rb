module Assembly
  module Instructions
    class Dec < Instruction
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value - 1)
        program.proceed
      end

      def ==(other)
        super && register == register
      end

      protected

      attr_reader :register
    end
  end
end