module Assembly
  module Instructions
    class Mul
      def initialize(target_register, source_register)
        @target_register = target_register
        @source_register = source_register
      end

      def execute(program)
        value = program.get_register(target_register) * program.get_register(source_register)
        program.set_register(target_register, value)
        program.proceed
      end

      private

      attr_reader :target_register, :source_register
    end
  end
end