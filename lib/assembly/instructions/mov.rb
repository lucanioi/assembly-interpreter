module Assembly
  module Instructions
    class Mov
      def initialize(register, value)
        @register = register
        @value = value
      end

      def execute(program)
        v = program.get_register(value)
        program.set_register(register, v)
        program.proceed
      end

      private

      attr_reader :register, :value
    end
  end
end