module Assembly
  module Instructions
    class Msg
      def initialize(*arguments)
        @arguments = arguments
      end

      def execute(program)
        program.output = concoct_message(program)
        program.proceed
      end

      private

      attr_reader :arguments

      def concoct_message(program)
        arguments.map do |argument|
          argument.is_a?(Symbol) ? program.get_register(argument) : argument
        end.join
      end
    end
  end
end