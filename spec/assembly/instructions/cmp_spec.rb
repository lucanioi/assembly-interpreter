describe Assembly::Instructions::Cmp do
  subject(:cmp_instruction) { described_class.new(x, y) }
  let(:x) { :b }
  let(:y) { :g }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  describe '#execute' do
    before do
      program.set_register(x, 10)
      program.set_register(y, 12)
    end

    it 'sets the last cmp of the program with the given values' do
      subject.execute(program)

      expected = Assembly::Comparison.new(10, 12)
      expect(program.last_cmp).to eq expected
    end

    it 'increments the instruction pointer' do
      original_pointer = program.instruction_pointer

      subject.execute(program)

      expected_pointer = original_pointer + 1
      expect(program.instruction_pointer).to eq expected_pointer
    end
  end
end
