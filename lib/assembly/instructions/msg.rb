require_relative 'instruction'

module Assembly
  module Instructions
    class Msg < Instruction
      def initialize(*arguments)
        @arguments = arguments
      end

      def execute(program)
        program.output = concoct_message(program)
        program.proceed
      end

      def ==(other)
        super &&
          arguments == other.arguments
      end

      protected

      attr_reader :arguments

      private

      def concoct_message(program)
        arguments.map do |argument|
          argument.is_a?(Symbol) ? program.get_register(argument) : argument
        end.join
      end
    end
  end
end
