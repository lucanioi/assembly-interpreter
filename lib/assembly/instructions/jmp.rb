require_relative 'instruction'

module Assembly
  module Instructions
    class Jmp < Instruction
      def initialize(label)
        @label = label
      end

      def execute(program)
        if desired_last_cmp?(program)
          program.jump_to_subprogram(label)
        end

        program.proceed
      end

      def ==(other)
        super &&
        label == other.label
      end

      protected

      attr_reader :label

      private

      def desired_last_cmp?(_program)
        true
      end
    end
  end
end