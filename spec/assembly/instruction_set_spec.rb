describe Assembly::InstructionSet do
  let(:instruction_set) { described_class.new(raw_program) }
  let(:out_of_bounds_error) { described_class::OutOfBounds }
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
      expect(instruction_set.instructions).to have(4).items
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
        expect(instruction_set.instructions).to have(4).items
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

          function:
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
          function: 6,
          print: 10
        }
      end

      it 'includes the lables in the list of instructions' do
        expect(instruction_set.instructions).to have(12).items
      end

      it 'scans for labels while taking note of the first line number of its subprogram' do
        expect(instruction_set.labels).to eq(labels)
      end
    end
  end

  describe '#get' do
    let(:instruction) { double(:instruction) }
    let(:instruction_klass) { double(:instruction_klass) }

    before do
      stub_const('Assembly::Instruction', instruction_klass)
      allow(instruction_klass).to receive(:new) { instruction }
    end

    it 'returns the instruction at the given line number' do
      expect(instruction_klass).to receive(:new).with('mov  a, 5')

      expect(instruction_set.get(0)).to eq instruction
    end

    context 'when the line number is out of bounds' do
      it 'raises an instruction-out-of-bounds error' do
        expect { instruction_set.get(100) }.to raise_error out_of_bounds_error
      end
    end
  end
end