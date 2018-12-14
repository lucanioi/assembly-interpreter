require_relative 'assembly_error'

module Assembly
  class Program
    EmptyReturnTarget = Class.new(AssemblyError)

    attr_reader :instruction_pointer, :registry, :ret_targets
    attr_accessor :output, :last_cmp

    def initialize(instruction_set, registry)
      @instruction_set = instruction_set
      @registry = registry

      @instruction_pointer = 0
      @ret_targets = []
      @last_cmp = nil
      @output = nil
      @finished = false
    end

    def proceed
      @instruction_pointer += 1
    end

    def jump_to_subprogram(subprogram)
      ret_targets.push(instruction_pointer)
      @instruction_pointer = instruction_set.labels[subprogram]
    end

    def return_to_last_target
      @instruction_pointer = ret_targets.pop || (raise EmptyReturnTarget)
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