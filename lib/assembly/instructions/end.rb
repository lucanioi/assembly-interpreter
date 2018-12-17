module Assembly
  module Instructions
    class End
      def execute(program)
        program.finish
      end
    end
  end
end