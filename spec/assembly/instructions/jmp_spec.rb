# describe Assembly::Instructions::Jmp do
#   subject(:jmp_instruction) { described_class.new(label) }
#   let(:label) { :function }
#   let(:program) { double(:program) }

#   describe '#execute' do
#     it 'sets the last cmp of the program with the given values' do
#       subject.execute(program)

#       expected = Assembly::Comparison.new(10, 12)
#       expect(program.last_cmp).to eq expected
#     end

#     it 'increments the instruction pointer' do
#       original_pointer = program.instruction_pointer

#       subject.execute(program)

#       expected_pointer = original_pointer + 1
#       expect(program.instruction_pointer).to eq expected_pointer
#     end
#   end
# end