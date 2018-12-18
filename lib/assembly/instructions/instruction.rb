module Assembly
  module Instructions
    class Instruction
      def ==(other)
        self.class == other.class
      end
    end
  end
end