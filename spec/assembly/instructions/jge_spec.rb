require 'support/jump_shared_examples'

describe Assembly::Instructions::Jge do
  it_behaves_like 'jump if last cmp was', :greater_or_equal?
end
