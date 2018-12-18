module Assembly
  module Instructions
    class Instruction
      def ==(other)
        self.class == other.class
      end

      def to_s
        arguments = instance_variables.map { |v| instance_variable_get(v) }
        arguments.map! do |arg|
          arg.is_a?(String) ? "'#{arg}'" : arg
        end

        instruction_name = self.class.name.delete_prefix('Assembly::Instructions::').downcase

        "#{instruction_name}  #{arguments.join(', ')}"
      end
    end
  end
end