module Assembly
  module Instructions
    class Call
      def initialize(label)
        @label = label
      end

      def execute(program)
        program.call_subprogram(label)
        program.proceed
      end

      attr_reader :label
    end
  end
end