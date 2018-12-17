describe Assembly::Instructions::Add do
  subject(:add_instruction) { described_class.new(target_register, source_register) }
  let(:target_register) { :a }
  let(:source_register) { :b }

  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  before do
    program.set_register(target_register, 100)
    program.set_register(source_register, 88) if source_register.is_a? Symbol
  end

  describe '#execute' do
    it 'adds the values together' do
      subject.execute(program)

      expect(program.get_register(target_register)).to eq 188
    end

    context 'when source register is just a raw-value integer' do
      let(:source_register) { 100 }

      it 'copies the integer into the register' do
        subject.execute(program)

        expect(program.get_register(target_register)).to eq 200
      end
    end

    it 'increments the instruction pointer' do
      original_pointer = program.instruction_pointer

      subject.execute(program)

      expected_pointer = original_pointer + 1
      expect(program.instruction_pointer).to eq expected_pointer
    end
  end
end


