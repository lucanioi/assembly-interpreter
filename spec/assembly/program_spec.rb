describe Assembly::Program do
  subject(:program) { described_class.new(instruction_set, registry) }
  let(:instruction_set) { double(:instruction_set) }
  let(:registry) { double(:registry) }
  let(:instruction) { double(:instruction) }
  let(:empty_return_target_error) { Assembly::Errors::EmptyReturnTarget }

  before do
    allow(instruction_set).to receive(:labels) do
      {
        function: 15,
        print: 20
      }
    end
  end

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

    it 'moves the instruction pointer down one line' do
      program.proceed

      expect(program.instruction_pointer).to eq 1
    end
  end

  describe '#jump_to_subprogram' do
    it 'jumps the pointer to the first line of the given subprogram' do
      program.jump_to_subprogram(:function)

      expect(program.instruction_pointer).to eq 15
    end

    it 'stores the current pointer as a return target' do
      program.jump_to_subprogram(:function)
      program.jump_to_subprogram(:print)

      expect(program.ret_targets).to eq [0, 15]
    end
  end

  describe '#return_to_last_target' do
    context 'when there are return targets' do
      before do
        program.jump_to_subprogram(:function)
        program.jump_to_subprogram(:print)
      end

      it 'sets the pointer to the last return target' do
        program.return_to_last_target

        expect(program.instruction_pointer).to eq 15
      end
    end

    context 'when there are no return targets' do
      it 'raises an error' do
        return_to_nothing = proc { program.return_to_last_target }

        expect(&return_to_nothing).to raise_error empty_return_target_error
      end
    end
  end
end
