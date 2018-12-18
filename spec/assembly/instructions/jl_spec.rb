require 'support/jump_shared_examples'

describe Assembly::Instructions::Jl do
  it_behaves_like 'jump if last cmp was', :less?
end
