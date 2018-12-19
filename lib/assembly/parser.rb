module Assembly
  module Parser
    class << self
      MATCHERS = {
        comment: /;.*$/,
        method: /\A([a-z0-9_]+)(?:\s+|\z)/,
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

      private

      def remove_comments(raw_program)
        raw_program.gsub(MATCHERS[:comment], '')
      end

      def parse_line(raw_line)
        return [raw_line.strip.to_sym] if label?(raw_line)

        method = parse_method(raw_line)
        args = parse_arguments(raw_line) if has_arguments?(raw_line)

        [method, *args]
      end

      def label?(raw_line)
        raw_line.match? MATCHERS[:label]
      end

      def parse_method(raw_line)
        extract(raw_line, :method).to_sym
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
