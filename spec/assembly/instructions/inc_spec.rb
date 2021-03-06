describe Assembly::Instructions::Inc do
  subject(:inc_instruction) { described_class.new(register) }
  let(:register) { :a }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  before do
    program.set_register(register, -18)
  end

  describe '#execute' do
    it 'increments the value in the register by one' do
      subject.execute(program)

      expect(program.get_register(register)).to eq -17
    end

    it 'increments the instruction pointer' do
      original_pointer = program.instruction_pointer

      subject.execute(program)

      expected_pointer = original_pointer + 1
      expect(program.instruction_pointer).to eq expected_pointer
    end
  end
end
