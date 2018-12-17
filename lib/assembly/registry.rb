module Assembly
  class Registry
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
      values[register] || (raise Errors::EmptyRegister)
    end

    private

    attr_reader :values

    def validate_register(register)
      unless REGISTERS.include?(register)
        raise Errors::InvalidRegister, "Specified register is invalid; it must be one of the following: #{REGISTERS}"
      end
    end
  end
end
