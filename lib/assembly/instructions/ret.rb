module Assembly
  module Instructions
    class Ret
      def execute(program)
        program.return_to_last_target
        program.proceed
      end
    end
  end
end