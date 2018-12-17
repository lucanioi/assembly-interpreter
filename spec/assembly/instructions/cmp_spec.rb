describe Assembly::Instructions::Cmp do
  subject(:cmp_instruction) { described_class.new(x, y) }
  let(:x) { 10 }
  let(:y) { 12 }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:instruction_set) { double(:instruction_set) }
  let(:registry) { double(:registry) }

  describe '#execute' do
    it 'sets the last cmp of the program' do
      cmp_instruction.execute(program)

      expected = Assembly::Comparison.new(x, y)
      expect(program.last_cmp).to eq expected
    end

    it 'calls proceed on the program' do
      expect(program).to receive(:proceed).once

      cmp_instruction.execute(program)
    end
  end
end