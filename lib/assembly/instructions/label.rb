module Assembly
  module Instructions
    Label = Struct.new(:identifier) do
      def to_s
        "label: #{identifier}"
      end
    end
  end
end
