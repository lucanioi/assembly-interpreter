module Assembly
  class Program
    attr_reader :instruction_pointer, :registry
    attr_accessor :output, :ret_target, :last_cmp

    def initialize(instruction_set, registry)
      @instruction_set = instruction_set
      @registry = registry

      @instruction_pointer = 0
      @ret_target = 0
      @last_cmp = nil
      @output = nil
      @finished = false
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