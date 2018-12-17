require 'support/jump_shared_examples'

describe Assembly::Instructions::Jne do
  it_behaves_like 'jump if last cmp was', :inequality?
end