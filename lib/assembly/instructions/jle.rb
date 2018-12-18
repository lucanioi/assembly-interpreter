require_relative 'jmp'

module Assembly
  module Instructions
    class Jle < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.less_or_equal?
      end
    end
  end
end
