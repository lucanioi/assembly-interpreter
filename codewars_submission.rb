def assembler_interpreter(program)
  Assembly::Interpreter.interpret(program)
end

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

module Assembly
  class Registry
    REGISTERS = (:a..:z).to_a.freeze

    def initialize
      @values = {}
    end

    def insert(value, at:)
      register = at
      validate_register(register)
      values[register] = value
    end

    def read(register)
      validate_register(register)
      values[register] || (raise Errors::EmptyRegister)
    end

    private

    attr_reader :values

    def validate_register(register)
      unless REGISTERS.include?(register)
        raise Errors::InvalidRegister, "Specified register is invalid; it must be one of the following: #{REGISTERS}"
      end
    end
  end
end

module Assembly
  class Program
    attr_reader :instruction_pointer, :registry, :ret_targets
    attr_accessor :output, :last_cmp

    def initialize(instruction_set, registry)
      @instruction_set = instruction_set
      @registry = registry

      @instruction_pointer = 0
      @ret_targets = []
      @last_cmp = NilComparison.new
      @output = nil
      @finished = false
    end

    def get_register(value_or_variable)
      return value_or_variable if value_or_variable.is_a? Integer

      registry.read(value_or_variable)
    end

    def set_register(variable, value)
      registry.insert(value, at: variable)
    end

    def proceed
      @instruction_pointer += 1
    end

    def call_subprogram(subprogram)
      ret_targets.push(instruction_pointer)
      jump_to_subprogram(subprogram)
    end

    def jump_to_subprogram(subprogram)
      @instruction_pointer = instruction_set.line_number(label: subprogram)
    end

    def return_to_last_target
      @instruction_pointer = ret_targets.pop || (raise Errors::EmptyReturnTarget)
    end

    def current_instruction
      instruction_set.get(instruction_pointer)
    end

    def finished?
      @finished
    end

    def finish
      @finished = true
      freeze
    end

    private

    attr_reader :instruction_set
  end
end

module Assembly
  class InstructionSet
    attr_reader :instructions, :labels

    def initialize(raw_instructions)
      @instructions = create_instructions(raw_instructions)
      @labels = {}
      scan_labels
    end

    def get(line_number)
      instructions[line_number] || (raise Errors::InstructionOutOfBounds)
    end

    def line_number(label:)
      labels.fetch(label) { raise Errors::InvalidIdentifier }
    end

    private

    def create_instructions(raw_instructions)
      Instructions::Parser.parse_instructions(raw_instructions)
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

module Assembly
  module Errors
    Error = Class.new(StandardError)

    InvalidValue = Class.new(Error)
    EmptyRegister = Class.new(Error)
    InvalidRegister = Class.new(Error)
    EmptyReturnTarget = Class.new(Error)
    InvalidIdentifier = Class.new(Error)
    InvalidInstruction = Class.new(Error)
    InstructionOutOfBounds = Class.new(Error)
  end
end

module Assembly
  class Comparison
    def initialize(x, y)
      validate(x, y)
      @x = x
      @y = y
    end

    def greater?
      x > y
    end

    def greater_or_equal?
      x >= y
    end

    def equality?
      x == y
    end

    def less_or_equal?
      x <= y
    end

    def less?
      x < y
    end

    def inequality?
      x != y
    end

    def ==(other)
      x == other.x && y == other.y
    end

    protected

    attr_reader :x, :y

    private

    def validate(x, y)
      unless x.is_a?(Integer) && y.is_a?(Integer)
        raise Errors::InvalidValue, 'x and y must be integers.'
      end
    end
  end

  class NilComparison
    def nil?; true end

    def greater?; false end
    def greater_or_equal?; false end
    def equality?; false end
    def less_or_equal?; false end
    def less?; false end
    def inequality?; false end

    def ==(other)
      other.nil?
    end
  end
end

module Assembly
  module Instructions
    module Factory
      class << self
        INSTRUCTIONS = %i[mov inc dec add sub mul div jmp cmp
                        jne je jge jg jle jl call ret msg end].freeze

        def create(instruction, *arguments)
          return create_label(instruction.to_s) if Parser.label?(instruction)

          validate!(instruction)
          instruction_klass(instruction).new(*arguments)
        end

        private

        def create_label(raw_label)
          Label.new(raw_label.strip.delete_suffix(':').to_sym)
        end

        def validate!(instruction)
          unless INSTRUCTIONS.include?(instruction)
            raise Errors::InvalidInstruction, "#{instruction} is an invalid instruction"
          end
        end

        def instruction_klass(instruction)
          Instructions.const_get(instruction.to_s.capitalize)
        end
      end
    end
  end
end

module Assembly
  module Instructions
    class Instruction
      def ==(other)
        self.class == other.class
      end

      def to_s
        arguments =
          instance_variables
            .map { |v| instance_variable_get(v) }
            .map { |arg| arg.is_a?(String) ? "'#{arg}'" : arg }

        instruction_name =
          self.class
            .name
            .delete_prefix('Assembly::Instructions::')
            .downcase

        "#{instruction_name}  #{arguments.join(', ')}"
      end
    end
  end
end

module Assembly
  module Instructions
    class ArithmeticInstruction < Instruction
      def initialize(target_register, source_register)
        @target_register = target_register
        @source_register = source_register
      end

      def execute(program)
        x_value = program.get_register(target_register)
        y_value = program.get_register(source_register)
        value = compute(x_value, y_value)

        program.set_register(target_register, value)
        program.proceed
      end

      def ==(other)
        super &&
          target_register == other.target_register &&
          source_register == other.source_register
      end

      protected

      attr_reader :target_register, :source_register

      private

      def compute(_x_value, _y_value)
        raise NotImplementedError
      end
    end
  end
end

module Assembly
  module Instructions
    class Add < ArithmeticInstruction
      def compute(x_value, y_value)
        x_value + y_value
      end
    end
  end
end

module Assembly
  module Instructions
    class Sub < ArithmeticInstruction
      def compute(x_value, y_value)
        x_value - y_value
      end
    end
  end
end

module Assembly
  module Instructions
    class Mul < ArithmeticInstruction
      def compute(x_value, y_value)
        x_value * y_value
      end
    end
  end
end

module Assembly
  module Instructions
    class Div < ArithmeticInstruction
      def compute(x_value, y_value)
        x_value / y_value
      end
    end
  end
end

module Assembly
  module Instructions
    class Call < Instruction
      def initialize(label)
        @label = label
      end

      def execute(program)
        program.call_subprogram(label)
        program.proceed
      end

      def ==(other)
        super && label == other.label
      end

      protected

      attr_reader :label
    end
  end
end

module Assembly
  module Instructions
    class Cmp < Instruction
      def initialize(x, y)
        @x = x
        @y = y
      end

      def execute(program)
        x_val = program.get_register(x)
        y_val = program.get_register(y)
        program.last_cmp = Comparison.new(x_val, y_val)
        program.proceed
      end

      def ==(other)
        super &&
          x == other.x &&
          y == other.y
      end

      protected

      attr_reader :x, :y
    end
  end
end

module Assembly
  module Instructions
    class Dec < Instruction
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value - 1)
        program.proceed
      end

      def ==(other)
        super && register == other.register
      end

      protected

      attr_reader :register
    end
  end
end

module Assembly
  module Instructions
    class Inc < Instruction
      def initialize(register)
        @register = register
      end

      def execute(program)
        value = program.get_register(register)
        program.set_register(register, value + 1)
        program.proceed
      end

      def ==(other)
        super && register == other.register
      end

      private

      attr_reader :register
    end
  end
end

module Assembly
  module Instructions
    class Jmp < Instruction
      def initialize(label)
        @label = label
      end

      def execute(program)
        desired_last_cmp?(program) && program.jump_to_subprogram(label)
        program.proceed
      end

      def ==(other)
        super && label == other.label
      end

      protected

      attr_reader :label

      private

      def desired_last_cmp?(_program)
        true
      end
    end
  end
end

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

module Assembly
  module Instructions
    class Jg < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.greater?
      end
    end
  end
end

module Assembly
  module Instructions
    class Jge < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.greater_or_equal?
      end
    end
  end
end

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

module Assembly
  module Instructions
    class Jle < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.less_or_equal?
      end
    end
  end
end

module Assembly
  module Instructions
    class Jne < Jmp
      private

      def desired_last_cmp?(program)
        program.last_cmp.inequality?
      end
    end
  end
end

module Assembly
  module Instructions
    class End < Instruction
      def execute(program)
        program.finish
      end
    end
  end
end

module Assembly
  module Instructions
    Label = Struct.new(:identifier) do
      def to_s
        "label: #{identifier}"
      end
    end
  end
end

module Assembly
  module Instructions
    class Mov < Instruction
      def initialize(register, value)
        @register = register
        @value = value
      end

      def execute(program)
        val = program.get_register(value)
        program.set_register(register, val)
        program.proceed
      end

      def ==(other)
        super &&
          register == other.register
          value == other.value
      end

      protected

      attr_reader :register, :value
    end
  end
end

module Assembly
  module Instructions
    class Msg < Instruction
      def initialize(*arguments)
        @arguments = arguments
      end

      def execute(program)
        program.output = concoct_message(program)
        program.proceed
      end

      def ==(other)
        super && arguments == other.arguments
      end

      protected

      attr_reader :arguments

      private

      def concoct_message(program)
        arguments.map do |argument|
          argument.is_a?(Symbol) ? program.get_register(argument) : argument
        end.join
      end
    end
  end
end

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

module Assembly
  module Instructions
    module Parser
      class << self
        MATCHERS = {
          comment: /;.*$/,
          instruction: /\A([a-z0-9_]+)(?:\s+|\z)/,
          arguments: /\A[a-z0-9_]+\s+(.+)/,
          argument: /'[^']*'|[^,\s]+/,
          register: /\A[a-z]+\z/,
          integer: /\A-?\d+\z/,
          string: /\A'(.*)'\z/,
          label: /\A[a-z0-9_]+:\z/,
          subprogram: /\A[a-z0-9_]+\z/
        }.freeze

        def parse_instructions(raw_program)
          remove_comments(raw_program)
            .lines
            .map(&:strip)
            .reject(&:empty?)
            .map(&method(:parse_line))
        end

        def label?(raw_line)
          raw_line.match? MATCHERS[:label]
        end

        private

        def remove_comments(raw_program)
          raw_program.gsub(MATCHERS[:comment], '')
        end

        def parse_line(raw_line)
          return [raw_line.strip.to_sym] if label?(raw_line)

          instruction = parse_instruction(raw_line)
          args = parse_arguments(raw_line) if has_arguments?(raw_line)

          [instruction, *args]
        end

        def parse_instruction(raw_line)
          extract(raw_line, :instruction).to_sym
        end

        def extract(raw_line, matcher_type)
          match = raw_line.match(MATCHERS[matcher_type])
          unless match
            raise Errors::InvalidInstruction,
              "Could not extract #{matcher_type} from '#{raw_line}'"
          end
          match.captures.first
        end

        def has_arguments?(raw_line)
          raw_line.match?(MATCHERS[:arguments])
        end

        def parse_arguments(raw_line)
          extract(raw_line, :arguments)
            .yield_self(&method(:split_args))
            .map(&method(:parse_arg))
        end

        def split_args(raw_args)
          raw_args.scan(MATCHERS[:argument])
        end

        def parse_arg(arg)
          case arg
          when MATCHERS[:register] then arg.to_sym
          when MATCHERS[:integer] then arg.to_i
          when MATCHERS[:string] then arg.delete_prefix("'").delete_suffix("'")
          when MATCHERS[:subprogram] then arg.to_sym
          else
            raise Errors::InvalidInstruction, "\"#{arg}\" is an invalid argument."
          end
        end
      end
    end
  end
end

