module Assembly
  module Instructions
    class Dec
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.registry.read(register)
        program.registry.insert(value - 1, at: register)
        program.proceed
      end

      private

      attr_reader :register
    end
  end
end