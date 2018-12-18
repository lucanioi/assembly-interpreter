module Assembly
  module Instructions
    class Dec
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value - 1)
        program.proceed
      end

      def ==(other)
        self.class == other.class &&
        register == register
      end

      protected

      attr_reader :register
    end
  end
end