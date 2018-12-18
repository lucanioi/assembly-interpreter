require 'support/jump_shared_examples'

describe Assembly::Instructions::Jg do
  it_behaves_like 'jump if last cmp was', :greater?
end
