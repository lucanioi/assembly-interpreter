require_relative 'jmp'

module Assembly
  module Instructions
    class Jge < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.greater_or_equal?
      end
    end
  end
end
