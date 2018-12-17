require 'support/arithmetic_shared_examples'

describe Assembly::Instructions::Mul do
  it_behaves_like 'arithmetic operation', :multiplication
end
