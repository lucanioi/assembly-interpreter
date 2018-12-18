require_relative 'jmp'

module Assembly
  module Instructions
    class Jne < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.inequality?
      end
    end
  end
end
