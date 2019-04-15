module Assembly
  module Instructions
    Label = Struct.new(:identifier) do
      def to_s
        "label: #{identifier}"
      end

      def execute(program)
        program.proceed
      end
    end
  end
end
