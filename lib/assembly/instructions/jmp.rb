module Assembly
  module Instructions
    class Jmp
      def initialize(label)
        @label = label
      end

      def execute(program)
        if desired_last_cmp?(program)
          program.jump_to_subprogram(label)
        end

        program.proceed
      end

      private

      def desired_last_cmp?(_program)
        true
      end

      attr_reader :label
    end
  end
end