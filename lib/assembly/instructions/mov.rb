module Assembly
  module Instructions
    class Mov
      def initialize(register, value_or_register)
        @register = register
        @value_or_register = value_or_register
      end

      def execute(program)
        value = program.registry.read(value_or_register) || value_or_register
        program.registry.insert(value, at: register)
        program.proceed
      end

      private

      attr_reader :register, :value_or_register
    end
  end
end