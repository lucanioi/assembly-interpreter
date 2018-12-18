require 'support/jump_shared_examples'

describe Assembly::Instructions::Je do
  it_behaves_like 'jump if last cmp was', :equality?
end
