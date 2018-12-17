describe Assembly::Instructions::Mov do
  subject(:mov_instruction) { described_class.new(target_register, source_register) }
  let(:target_register) { :a }
  let(:source_register) { :b }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  before do
    program.set_register(source_register, 90)
  end

  describe '#execute' do
    it 'copies the value in to the register' do
      subject.execute(program)

      expect(program.get_register(target_register)).to eq 90
    end

    it 'increments the instruction pointer' do
      original_pointer = program.instruction_pointer

      subject.execute(program)

      expected_pointer = original_pointer + 1
      expect(program.instruction_pointer).to eq expected_pointer
    end
  end
end