module Assembly
  module Interpreter
    class << self
      def interpret(raw_program)
        program = setup_program(raw_program)

        until program.finished?
          program.current_instruction.execute(program)
        end

        program.output
      rescue Assembly::Errors::Error
        -1
      end

      private

      def setup_program(raw_program)
        instruction_set = InstructionSet.new(raw_program)
        registry = Registry.new
        Program.new(instruction_set, registry)
      end
    end
  end
end
