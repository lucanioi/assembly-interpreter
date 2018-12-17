module Assembly
  module Instructions
    class Inc
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value + 1)
        program.proceed
      end

      private

      attr_reader :register
    end
  end
end