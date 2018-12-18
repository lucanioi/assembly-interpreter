module Assembly
  module Interpreter
    class << self
      def interpret(raw_program)
        instruction_set = InstructionSet.new(raw_program)
        registry = Registry.new

        program = Program.new(instruction_set, registry)

        until program.finished?
          instruction = program.current_instruction
          instruction.execute(program)
        end

        program.output

      rescue Errors::Error
        -1
      end
    end
  end
end