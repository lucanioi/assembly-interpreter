require_relative 'assembly_error.rb'

module Assembly
  class Registry
    InvalidRegister = Class.new(AssemblyError)
    EmptyRegister = Class.new(AssemblyError)

    REGISTERS = (:a..:z).to_a.freeze

    def initialize
      @values = {}
    end

    def insert(value, at:)
      register = at
      validate_register(register)
      values[register] = value
    end

    def read(register)
      validate_register(register)
      values[register] || (raise EmptyRegister)
    end

    private

    attr_reader :values

    def validate_register(register)
      unless REGISTERS.include?(register)
        raise InvalidRegister, "Specified register is invalid; it must be one of the following: #{REGISTERS}"
      end
    end
  end
end
