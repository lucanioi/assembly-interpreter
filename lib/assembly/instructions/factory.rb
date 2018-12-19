require_relative '../errors'
require_relative 'label'
require_relative 'parser'

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
