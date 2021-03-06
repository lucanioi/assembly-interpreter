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
      @current_subprogram = subprogram
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

    def to_s
      "line: #{instruction_pointer}\n" \
      "ret targets: #{ret_targets}\n" \
      "registry:\n#{registry}"
    end

    private

    attr_reader :instruction_set, :current_subprogram
  end
end
