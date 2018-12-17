require 'support/arithmetic_shared_examples'

describe Assembly::Instructions::Sub do
  it_behaves_like 'arithmetic operation', :subtraction
end
