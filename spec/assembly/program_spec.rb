describe Assembly::Program do
  subject(:program) { described_class.new(instruction_set, registry) }
  let(:instruction_set) { double(:instruction_set) }
  let(:registry) { double(:registry) }
  let(:instruction) { double(:instruction) }

  describe '#current_instruction' do
    before do
      allow(instruction_set).to receive(:get).with(program.instruction_pointer) { instruction }
    end

    it 'retrieves the instruction at the current pointer' do
      expect(program.current_instruction).to eq instruction
    end
  end

  describe '#instruction_pointer' do
    it 'is set to 0 by default' do
      expect(program.instruction_pointer).to eq 0
    end
  end

  describe '#proceed' do
    before do
      allow(instruction_set).to receive(:get) { instruction }
      allow(instruction).to receive(:end?) { false }
    end

    it 'increases moves the instruction pointer down one line' do
      program.proceed

      expect(program.instruction_pointer).to eq 1
    end

    context 'when program reaches the end' do
      let(:end_instruction) { double(:end_instruction) }

      before do
        allow(end_instruction).to receive(:end?) { true }
        allow(instruction_set).to receive(:get) { end_instruction }
      end

      it 'finishes the program' do
        program.proceed

        expect(program.finished?).to be true
      end
    end
  end

  describe '#jump_to_subprogram' do
    before do
      allow(instruction_set).to receive(:labels) do
        {
          function: 15,
          print: 20
        }
      end
    end

    it 'jumps the pointer to the first line of the given subprogram' do
      program.jump_to_subprogram(:function)

      expect(program.instruction_pointer).to eq 15
    end
  end
end
