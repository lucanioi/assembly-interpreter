require_relative 'instruction'

module Assembly
  module Instructions
    class Call < Instruction
      def initialize(label)
        @label = label
      end

      def execute(program)
        program.call_subprogram(label)
        program.proceed
      end

      def ==(other)
        super && label == other.label
      end

      protected

      attr_reader :label
    end
  end
end