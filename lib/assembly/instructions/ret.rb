require_relative 'instruction'

module Assembly
  module Instructions
    class Ret < Instruction
      def execute(program)
        program.return_to_last_target
        program.proceed
      end
    end
  end
end