describe Assembly::Instructions::Msg do
  subject(:msg_instruction) { described_class.new(*arguments) }
  let(:arguments) { %w(x\  +\  x\  =\  10) }
  let(:program) { Assembly::Program.new(instruction_set, registry) }
  let(:registry) { Assembly::Registry.new }
  let(:instruction_set) { double(:instruction_set) }

  describe '#execute' do
    it 'sets the message to program\'s output' do
      subject.execute(program)

      expect(program.output).to eq 'x + x = 10'
    end

    context 'when there are variables in the message' do
      let(:arguments) { [:x, ' + ', :x, ' = ', '10'] }

      before do
        program.set_register(:x, 5)
      end

      it 'converts them into values' do
        subject.execute(program)

        expect(program.output).to eq '5 + 5 = 10'
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