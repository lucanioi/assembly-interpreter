require_relative 'instruction'

module Assembly
  module Instructions
    class End < Instruction
      def execute(program)
        program.finish
      end
    end
  end
end