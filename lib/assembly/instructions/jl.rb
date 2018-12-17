require_relative 'jmp'

module Assembly
  module Instructions
    class Jl < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.less?
      end
    end
  end
end