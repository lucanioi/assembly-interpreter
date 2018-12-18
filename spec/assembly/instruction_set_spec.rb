describe Assembly::InstructionSet do
  subject(:instruction_set) { described_class.new(raw_program) }
  let(:out_of_bounds_error) { Assembly::Errors::InstructionOutOfBounds }
  let(:invalid_label_error) { Assembly::Errors::InvalidIdentifier }
  let(:raw_program) do
    <<~PROGRAM
      mov  a, 5
      inc  a
      call function
      end
    PROGRAM
  end

  describe 'initialization' do
    it 'separates the program by lines' do
      expect(get_instructions(instruction_set)).to have(4).items
    end

    context 'when program includes comments' do
      let(:raw_program) do
        <<~PROGRAM
          ; i am a comment
          mov  a, 5
          inc  a
          call function ; comment
          end
        PROGRAM
      end

      it 'omits the comments from the instruction lines' do
        expect(get_instructions(instruction_set)).to have(4).items
      end
    end

    context 'when program includes labels' do
      let(:raw_program) do
        <<~PROGRAM
          mov  a, 5
          inc  a
          call function
          call print
          end

          function1:
            mov a, b
            inc a
            ret

          print:
            msg 'hello world'
            ret
        PROGRAM
      end

      let(:labels) do
        {
          function1: 5,
          print: 9
        }
      end

      it 'includes the lables in the list of instructions' do
        expect(get_instructions(instruction_set)).to have(12).items
      end

      it 'scans for labels and records their line numbers' do
        expect(subject.send(:labels)).to eq(labels)
      end
    end
  end

  describe '#get' do
    let(:instruction) { double(:instruction) }
    let(:instruction_factory) { double(:instruction_factory) }

    before do
      stub_const('Assembly::Instructions::Factory', instruction_factory)
      allow(instruction_factory).to receive(:create) { instruction }
    end

    it 'returns the instruction at the given line number' do
      expect(instruction_factory).to receive(:create).with('mov  a, 5')

      expect(subject.get(0)).to eq instruction
    end

    context 'when the line number is out of bounds' do
      it 'raises an instruction-out-of-bounds error' do
        expect { subject.get(100) }.to raise_error out_of_bounds_error
      end
    end
  end

  describe '#line_number' do
    let(:raw_program) do
      <<~PROGRAM
        mov  a, 5
        inc  a
        call function
        call print
        end

        function:
          mov a, b
          inc a
          ret

        print:
          msg 'hello world'
          ret
      PROGRAM
    end

    it 'returns the line number of the given label' do
      actual_line_number = subject.line_number(label: :function)

      expect(actual_line_number).to eq 5
    end

    context 'when given label doesn\'t exist' do
      it 'raises an error' do
        invalid_label_call = proc { subject.line_number(label: :invalid_label) }

        expect(&invalid_label_call).to raise_error invalid_label_error
      end
    end
  end

  def get_instructions(instruction_set)
    instruction_set.send(:instructions)
  end
end