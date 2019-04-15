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

def visualize(prog_str, line_number)
  str = prog_str.lines.reject do |line|
    line.strip.empty?
  end.yield_self do |lines|
    lines.map!.with_index do |line, i|
      i == line_number ? line : line.prepend('    ')
    end.tap do |lines|
      lines[line_number].prepend(' >> ')
    end
  end.join

  puts `clear`
  puts str
  sleep 0.1
end

