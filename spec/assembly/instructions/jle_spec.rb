require 'support/jump_shared_examples'

describe Assembly::Instructions::Jle do
  it_behaves_like 'jump if last cmp was', :less_or_equal?
end