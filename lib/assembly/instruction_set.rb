require_relative 'assembly_error'

module Assembly
  class InstructionSet
    OutOfBounds = Class.new(AssemblyError)

    COMMENT_MATCHER = /;.*$/
    LABEL_MATCHER = /^[a-z_]+:$/
    EMPTY_STR = ''.freeze
    LABEL_DELIMITER = ':'.freeze

    attr_reader :instructions, :labels

    def initialize(raw_program)
      @instructions = parse_instructions(raw_program)
      @labels = {}
      scan_labels
    end

    def get(line_number)
      raise OutOfBounds unless instruction = instructions[line_number]
      Instruction.new(instruction)
    end

    private

    def parse_instructions(raw_program)
      remove_comments(raw_program)
        .lines
        .map(&:strip)
        .reject(&:empty?)
    end

    def remove_comments(raw_program)
      raw_program.gsub(COMMENT_MATCHER, EMPTY_STR)
    end

    def scan_labels
      instructions.each_with_index do |instruction, index|
        add_label(instruction, index) if label?(instruction)
      end
    end

    def label?(line)
      line.match? LABEL_MATCHER
    end

    def add_label(label, label_index)
      label = label.delete_suffix(LABEL_DELIMITER).to_sym
      first_line_of_subprogram = label_index + 1
      labels[label] = first_line_of_subprogram
    end
  end
end
