require_relative 'jmp'

module Assembly
  module Instructions
    class Jg < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.greater?
      end
    end
  end
end
