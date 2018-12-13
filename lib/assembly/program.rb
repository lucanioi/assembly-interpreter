module Assembly
  class Program
    attr_reader :instruction_pointer, :registry, :ret_target
    attr_accessor :output, :last_cmp

    def initialize(instruction_set, registry)
      @instruction_set = instruction_set
      @registry = registry

      @instruction_pointer = 0
      @ret_target = 0
      @last_cmp = nil
      @output = nil
      @finished = false
    end

    def proceed
      @instruction_pointer += 1
      finish if current_instruction.end?
    end

    def jump_to_subprogram(subprogram)
      @instruction_pointer = instruction_set.labels[subprogram]
    end

    def current_instruction
      instruction_set.get(instruction_pointer)
    end

    def finished?
      @finished
    end

    def finish
      @finished = true
    end

    private

    attr_reader :instruction_set
  end
end