module Assembly
  module Instructions
    class Jmp
      def initialize(label)
        @label = label
      end

      def execute(program)
        program.jump_to_subprogram(label)
        program.proceed
      end

      private

      attr_reader :label
    end
  end
end