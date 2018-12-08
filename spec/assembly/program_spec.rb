describe Assembly::Program do
  subject(:program) { described_class.new(instruction_set, registry) }
  let(:instruction_set) { double(:instruction_set) }
  let(:registry) { double(:registry) }

  describe '#current_instruction' do
    let(:instruction) { double(:instruction) }

    before do
      allow(instruction_set).to receive(:get).with(program.instruction_pointer) { instruction }
    end

    it 'retrieves the instruction at the current pointer' do
      expect(program.current_instruction).to eq instruction
    end
  end
end