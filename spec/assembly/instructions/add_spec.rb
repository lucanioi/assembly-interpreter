require 'support/arithmetic_shared_examples'

describe Assembly::Instructions::Add do
  it_behaves_like 'arithmetic operation', :addition
end
