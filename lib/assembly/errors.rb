module Assembly
  module Errors
    Error = Class.new(StandardError)

    InvalidValue = Class.new(Error)
    EmptyRegister = Class.new(Error)
    InvalidRegister = Class.new(Error)
    EmptyReturnTarget = Class.new(Error)
    InstructionOutOfBounds = Class.new(Error)
  end
end