require_relative 'jmp'

module Assembly
  module Instructions
    class Je < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.equality?
      end
    end
  end
end
