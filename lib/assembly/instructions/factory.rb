require_relative '../errors'
require_relative 'label'

module Assembly
  module Instructions
    module Factory
      class << self
        INSTRUCTIONS =
          %w[mov inc dec add sub mul div jmp cmp jne je jge jg jle jl call ret msg end].freeze
        MATCHERS = {
          register: /\A[a-z]+\z/,
          integer: /\A-?\d+\z/,
          string: /\A'(.*)'\z/,
          arguments: /'[^']*'|[^,\s]+/,
          label: /\A[a-z0-9_]+:\z/,
          subprogram: /\A[a-z0-9_]+\z/
        }.freeze

        def create(raw_line)
          return label(raw_line) if label?(raw_line)

          klass = instruction_klass(raw_line)
          arguments = extract_arguments(raw_line)

          klass.new(*arguments)
        end

        private

        def label(raw_line)
          Label.new(raw_line.strip.delete_suffix(':').to_sym)
        end

        def label?(raw_line)
          raw_line.match? MATCHERS[:label]
        end

        def instruction_klass(raw_line)
          Instructions.const_get(extract_instruction(raw_line).capitalize)
        end

        def extract_instruction(raw_line)
          inst = INSTRUCTIONS.find { |instruction| raw_line.strip.start_with? instruction }
          inst || (raise Errors::InvalidInstruction, "#{raw_line} is an invalid instruction.")
        end

        def extract_arguments(raw_line)
          raw_line
            .delete_prefix(extract_instruction(raw_line))
            .yield_self(&method(:split_args))
            .map(&method(:parse_arg))
        end

        def split_args(raw_args)
          raw_args.scan(MATCHERS[:arguments])
        end

        def parse_arg(arg)
          case arg
          when MATCHERS[:register] then arg.to_sym
          when MATCHERS[:integer] then arg.to_i
          when MATCHERS[:string] then $1
          when MATCHERS[:subprogram] then arg.to_sym
          else
            raise Errors::InvalidInstruction, "\"#{arg}\" is an invalid argument."
          end
        end
      end
    end
  end
end