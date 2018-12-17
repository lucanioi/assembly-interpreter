module Assembly
  module Instructions
    class Jg
      def initialize(label)
        @label = label
      end

      def execute(program)
        if program.last_cmp.greater?
          program.jump_to_subprogram(label)
        end

        program.proceed
      end

      private

      attr_reader :label
    end
  end
end