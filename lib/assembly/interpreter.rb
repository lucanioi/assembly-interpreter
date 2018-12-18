module Assembly
  module Interpreter
    class << self
      def interpret(raw_program)
        program = setup_program(raw_program)

        until program.finished?
          instruction = program.current_instruction
          instruction.execute(program)
        end

        return program.output

      rescue Assembly::Errors::Error
        return -1
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