 require_relative 'instructions/factory'
 require_relative 'instructions/parser'
 require_relative 'instructions/label'

module Assembly
  class InstructionSet
    attr_reader :instructions, :labels

    def initialize(raw_instructions)
      @instructions = create_instructions(raw_instructions)
      @labels = {}
      scan_labels
    end

    def get(line_number)
      instruction = instructions[line_number]
      raise Errors::InstructionOutOfBounds if instruction.nil?
      instruction
    end

    def line_number(label:)
      labels.fetch(label) { raise Errors::InvalidIdentifier }
    end

    private

    def create_instructions(raw_instructions)
      Parser.parse_instructions(raw_instructions)
        .map(&method(:create_instruction))
    end

    def create_instruction(parsed_instruction)
      Instructions::Factory.create(*parsed_instruction)
    end

    def scan_labels
      instructions.each_with_index do |instruction, index|
        add_label(instruction, index) if label?(instruction)
      end

      labels.freeze
    end

    def label?(instruction)
      instruction.is_a? Instructions::Label
    end

    def add_label(label, label_index)
      labels[label.identifier] = label_index
    end
  end
end
