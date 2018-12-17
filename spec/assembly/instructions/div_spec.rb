require 'support/arithmetic_shared_examples'

describe Assembly::Instructions::Div do
  it_behaves_like 'arithmetic operation', :division
end
